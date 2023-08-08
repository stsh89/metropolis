pub type AppResult<T> = Result<T, AppError>;

#[derive(Clone)]
pub struct AppError {
    /// The gRPC status code, found in the `grpc-status` header.
    code: Code,

    /// A relevant error message, found in the `grpc-message` header.
    message: String,

    /// Optional underlying error.
    source: Option<std::sync::Arc<dyn std::error::Error + Send + Sync + 'static>>,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
enum Code {
    /// Client specified an invalid argument.
    InvalidArgument,

    /// Internal error.
    Internal,

    /// The system is not in a state required for the operation's execution.
    FailedPrecondition,
}

impl AppError {
    /// Create a new `Status` with the associated code and message.
    fn new(code: Code, message: impl Into<String>) -> Self {
        Self {
            code,
            message: message.into(),
            source: None,
        }
    }

    /// Get the  `Code` of this `AppError`.
    fn code(&self) -> Code {
        self.code
    }

    /// Get the text error message of this `Status`.
    fn message(&self) -> &str {
        &self.message
    }

    /// Client specified an invalid argument. Note that this differs from
    /// `FailedPrecondition`. `InvalidArgument` indicates arguments that are
    /// problematic regardless of the state of the system (e.g., a malformed file
    /// name).
    pub fn invalid_argument(message: impl Into<String>) -> Self {
        Self::new(Code::InvalidArgument, message)
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
        Self::new(Code::FailedPrecondition, message)
    }

    /// Internal errors. Means some invariants expected by underlying system has
    /// been broken. If you see one of these errors, something is very broken.
    pub fn internal(message: impl Into<String>) -> Self {
        Self::new(Code::Internal, message)
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

impl std::fmt::Debug for AppError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        // A manual impl to reduce the noise of frequently empty fields.
        let mut builder = f.debug_struct("AppError");

        builder.field("code", &self.code);

        if !self.message.is_empty() {
            builder.field("message", &self.message);
        }

        builder.field("source", &self.source);

        builder.finish()
    }
}

impl std::fmt::Display for AppError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            "status: {:?}, message: {:?}",
            self.code(),
            self.message(),
        )
    }
}

impl std::error::Error for AppError {
    fn source(&self) -> Option<&(dyn std::error::Error + 'static)> {
        self.source.as_ref().map(|err| (&**err) as _)
    }
}

impl From<tonic::Status> for AppError {
    fn from(value: tonic::Status) -> Self {
        match value.code() {
            tonic::Code::InvalidArgument => Self::invalid_argument(value.message()),
            tonic::Code::FailedPrecondition => Self::failed_precondition(value.message()),
            tonic::Code::Internal => Self::internal(value.message()),
            _ => Self::internal(value.message()),
        }
    }
}

impl From<AppError> for tonic::Status {
    fn from(value: AppError) -> tonic::Status {
        match value.code {
            Code::InvalidArgument => tonic::Status::invalid_argument(value.message),
            Code::FailedPrecondition => tonic::Status::failed_precondition(value.message),
            Code::Internal => tonic::Status::internal(value.message),
        }
    }
}
