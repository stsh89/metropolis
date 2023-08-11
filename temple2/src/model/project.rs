use super::UtcDateTime;
use uuid::Uuid;

pub struct Project {
    pub archivation_time: Option<UtcDateTime>,

    pub create_time: UtcDateTime,

    pub description: String,

    pub id: Uuid,

    pub name: String,

    pub slug: String,
}

impl Project {
    pub fn is_archived(&self) -> bool {
        self.archivation_time.is_some()
    }
}
