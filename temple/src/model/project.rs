use super::UtcDateTime;
use uuid::Uuid;

pub struct Project {
    pub create_time: UtcDateTime,

    pub description: String,

    pub id: Uuid,

    pub name: String,

    pub slug: String,
}
