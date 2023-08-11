use crate::{Utc, UtcDateTime, Uuid};

#[derive(Clone)]
pub struct Project {
    pub id: Uuid,

    pub archived_at: Option<UtcDateTime>,

    pub description: String,

    pub name: String,

    pub slug: String,

    pub inserted_at: UtcDateTime,

    pub updated_at: UtcDateTime,
}

impl Default for Project {
    fn default() -> Self {
        let now = Utc::now();

        Self {
            id: Uuid::new_v4(),
            archived_at: None,
            description: Default::default(),
            name: Default::default(),
            slug: Default::default(),
            inserted_at: now,
            updated_at: now,
        }
    }
}
