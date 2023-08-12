use crate::{Utc, UtcDateTime, Uuid};

#[derive(Clone)]
pub struct Model {
    pub id: Uuid,

    pub project_id: Uuid,

    pub description: String,

    pub name: String,

    pub slug: String,

    pub inserted_at: UtcDateTime,

    pub updated_at: UtcDateTime,
}

pub struct Attribute {
    pub id: Uuid,

    pub model_id: Uuid,

    pub description: String,

    pub kind: AttributeKind,

    pub name: String,

    pub inserted_at: UtcDateTime,

    pub updated_at: UtcDateTime,
}

#[derive(Default)]
pub enum AttributeKind {
    #[default]
    String,

    Int64,

    Bool,
}

pub struct Association {
    pub id: Uuid,

    pub description: String,

    pub kind: AssociationKind,

    pub model_id: Uuid,

    pub sub_model_id: Uuid,

    pub inserted_at: UtcDateTime,

    pub updated_at: UtcDateTime,
}

pub enum AssociationKind {
    BelongsTo,

    HasOne,

    ManyToMany,
}

impl Default for Model {
    fn default() -> Self {
        let now = Utc::now();

        Self {
            id: Uuid::new_v4(),
            project_id: Uuid::new_v4(),
            description: Default::default(),
            name: Default::default(),
            slug: Default::default(),
            inserted_at: now,
            updated_at: now,
        }
    }
}

impl Default for Attribute {
    fn default() -> Self {
        let now = Utc::now();

        Self {
            id: Uuid::new_v4(),
            model_id: Uuid::new_v4(),
            description: Default::default(),
            kind: Default::default(),
            name: Default::default(),
            inserted_at: now,
            updated_at: now,
        }
    }
}
