mod project;

use chrono::{DateTime, Utc};

pub use project::Project;

pub type UtcDateTime = DateTime<Utc>;
