mod attribute_types;
mod models;
mod projects;

use foundation::FoundationError;

pub use attribute_types::AttributeTypesRepo;
pub use models::ModelsRepo;
pub use projects::ProjectsRepo;

fn map_status_error(value: tonic::Status) -> FoundationError {
    match value.code() {
        tonic::Code::InvalidArgument => FoundationError::invalid_argument(value.message()),
        tonic::Code::FailedPrecondition => FoundationError::failed_precondition(value.message()),
        tonic::Code::Internal => FoundationError::internal(value.message()),
        _ => FoundationError::internal(value.message()),
    }
}
