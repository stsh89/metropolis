use foundation::{FoundationError, FoundationErrorCode};

pub type PortalResult<T> = Result<T, PortalError>;

#[derive(Clone)]
pub struct PortalError {
    /// The gRPC status code, found in the `grpc-status` header.
    code: PortalErrorCode,

    /// A relevant error message, found in the `grpc-message` header.
    message: String,

    /// Optional underlying error.
    source: Option<std::sync::Arc<dyn std::error::Error + Send + Sync + 'static>>,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub enum PortalErrorCode {
    /// Client specified an invalid argument.
    InvalidArgument,

    /// Internal error.
    Internal,

    /// The system is not in a state required for the operation's execution.
    FailedPrecondition,

    NotFound,
}

impl PortalError {
    /// Create a new `Status` with the associated code and message.
    fn new(code: PortalErrorCode, message: impl Into<String>) -> Self {
        Self {
            code,
            message: message.into(),
            source: None,
        }
    }

    /// Get the  `Code` of this `PortalError`.
    pub fn code(&self) -> PortalErrorCode {
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
        Self::new(PortalErrorCode::InvalidArgument, message)
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
        Self::new(PortalErrorCode::FailedPrecondition, message)
    }

    /// Internal errors. Means some invariants expected by underlying system has
    /// been broken. If you see one of these errors, something is very broken.
    pub fn internal(message: impl Into<String>) -> Self {
        Self::new(PortalErrorCode::Internal, message)
    }

    pub fn not_found(message: impl Into<String>) -> Self {
        Self::new(PortalErrorCode::NotFound, message)
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

impl std::fmt::Debug for PortalError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        // A manual impl to reduce the noise of frequently empty fields.
        let mut builder = f.debug_struct("PortalError");

        builder.field("code", &self.code);

        if !self.message.is_empty() {
            builder.field("message", &self.message);
        }

        builder.field("source", &self.source);

        builder.finish()
    }
}

impl std::fmt::Display for PortalError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            "status: {:?}, message: {:?}",
            self.code(),
            self.message(),
        )
    }
}

impl std::error::Error for PortalError {
    fn source(&self) -> Option<&(dyn std::error::Error + 'static)> {
        self.source.as_ref().map(|err| (&**err) as _)
    }
}

impl From<tonic::Status> for PortalError {
    fn from(value: tonic::Status) -> Self {
        match value.code() {
            tonic::Code::InvalidArgument => Self::invalid_argument(value.message()),
            tonic::Code::FailedPrecondition => Self::failed_precondition(value.message()),
            tonic::Code::Internal => Self::internal(value.message()),
            _ => Self::internal(value.message()),
        }
    }
}

impl From<PortalError> for tonic::Status {
    fn from(value: PortalError) -> tonic::Status {
        use PortalErrorCode::*;

        let mut error = match value.code {
            InvalidArgument => tonic::Status::invalid_argument(value.message),
            FailedPrecondition => tonic::Status::failed_precondition(value.message),
            Internal => tonic::Status::internal(value.message),
            NotFound => tonic::Status::not_found(value.message),
        };

        if let Some(source) = value.source {
            error.set_source(source);
        }

        error
    }
}

impl From<FoundationError> for PortalError {
    fn from(value: FoundationError) -> PortalError {
        use FoundationErrorCode::*;

        let error = match value.code() {
            InvalidArgument => PortalError::invalid_argument(value.message()),
            FailedPrecondition => PortalError::failed_precondition(value.message()),
            Internal => PortalError::internal(value.message()),
            NotFound => PortalError::not_found(value.message()),
        };

        // if let Some(source) = value.source().cloned() {
        //     error.set_source(source);
        // }

        error
    }
}
