use super::UtcDateTime;
use uuid::Uuid;

pub struct Project {
    pub id: Uuid,
    pub name: String,
    pub description: String,
    pub create_time: UtcDateTime,
}
