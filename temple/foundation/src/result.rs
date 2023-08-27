use crate::util::validator::{ValidationError, ValidationErrorKind};

pub type FoundationResult<T> = Result<T, FoundationError>;

#[derive(Clone)]
pub struct FoundationError {
    /// The code of an error.
    code: FoundationErrorCode,

    /// A relevant error message.
    message: String,

    /// Optional underlying error.
    source: Option<std::sync::Arc<dyn std::error::Error + Send + Sync + 'static>>,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub enum FoundationErrorCode {
    /// The system is not in a state required for the operation's execution.
    FailedPrecondition,

    /// Internal error.
    Internal,

    /// Client specified an invalid argument.
    InvalidArgument,

    /// Some requested entity was not found.
    NotFound,
}

impl FoundationError {
    /// Create a new `Status` with the associated code and message.
    fn new(code: FoundationErrorCode, message: impl Into<String>) -> Self {
        Self {
            code,
            message: message.into(),
            source: None,
        }
    }

    /// Get the  `Code` of this `FoundationError`.
    pub fn code(&self) -> FoundationErrorCode {
        self.code
    }

    /// Get the text error message of this `Status`.
    pub fn message(&self) -> &str {
        &self.message
    }

    /// Client specified an invalid argument. Note that this differs from
    /// `FailedPrecondition`. `InvalidArgument` indicates arguments that are
    /// problematic regardless of the state of the system (e.g., a malformed file
    /// name).
    pub fn invalid_argument(message: impl Into<String>) -> Self {
        Self::new(FoundationErrorCode::InvalidArgument, message)
    }

    /// Client specified an invalid argument. Note that this differs from
    /// `FailedPrecondition`. `InvalidArgument` indicates arguments that are
    /// problematic regardless of the state of the system (e.g., a malformed file
    /// name).
    pub fn not_found(message: impl Into<String>) -> Self {
        Self::new(FoundationErrorCode::NotFound, message)
    }

    /// Operation was rejected because the system is not in a state required for
    /// the operation's execution. For example, directory to be deleted may be
    /// non-empty, an rmdir operation is applied to a non-directory, etc.
    ///
    /// A litmus test that may help a service implementor in deciding between
    /// `FailedPrecondition`, `Aborted`, and `Unavailable`:
    /// (a) Use `Unavailable` if the client can retry just the failing call.
    /// (b) Use `Aborted` if the client should retry at a higher-level (e.g.,
    ///     restarting a read-modify-write sequence).
    /// (c) Use `FailedPrecondition` if the client should not retry until the
    ///     system state has been explicitly fixed.  E.g., if an "rmdir" fails
    ///     because the directory is non-empty, `FailedPrecondition` should be
    ///     returned since the client should not retry unless they have first
    ///     fixed up the directory by deleting files from it.
    pub fn failed_precondition(message: impl Into<String>) -> Self {
        Self::new(FoundationErrorCode::FailedPrecondition, message)
    }

    /// Internal errors. Means some invariants expected by underlying system has
    /// been broken. If you see one of these errors, something is very broken.
    pub fn internal(message: impl Into<String>) -> Self {
        Self::new(FoundationErrorCode::Internal, message)
    }

    /// Add a source error to this status.
    pub fn set_source(
        &mut self,
        source: std::sync::Arc<dyn std::error::Error + Send + Sync + 'static>,
    ) -> &mut Self {
        self.source = Some(source);
        self
    }
}

impl std::fmt::Debug for FoundationError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        // A manual impl to reduce the noise of frequently empty fields.
        let mut builder = f.debug_struct("FoundationError");

        builder.field("code", &self.code);

        if !self.message.is_empty() {
            builder.field("message", &self.message);
        }

        builder.field("source", &self.source);

        builder.finish()
    }
}

impl std::fmt::Display for FoundationError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            "status: {:?}, message: {:?}",
            self.code(),
            self.message(),
        )
    }
}

impl std::error::Error for FoundationError {
    fn source(&self) -> Option<&(dyn std::error::Error + 'static)> {
        self.source.as_ref().map(|err| (&**err) as _)
    }
}

impl From<ValidationError> for FoundationError {
    fn from(value: ValidationError) -> Self {
        use ValidationErrorKind::*;

        let ValidationError { field_name, kind } = value;

        match kind {
            Required => {
                let message = format!("{field_name} can't be blank");
                FoundationError::invalid_argument(message)
            }
            MaxLength(max) => {
                let message = format!("{field_name} is too long, maximum length is {max} bytes");
                FoundationError::invalid_argument(message)
            }
        }
    }
}
