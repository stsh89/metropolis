mod project;

use chrono::{DateTime, Utc};

pub use project::Project;
pub use uuid::Uuid;

pub type UtcDateTime = DateTime<Utc>;
