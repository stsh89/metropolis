use crate::{UtcDateTime, Uuid};

pub struct Model {
    pub id: Uuid,

    pub description: String,

    pub name: String,

    pub project_id: Uuid,

    pub slug: String,

    pub inserted_at: UtcDateTime,

    pub updated_at: UtcDateTime,
}

pub struct Attribute {
    pub id: Uuid,

    pub description: String,

    pub kind: AttributeKind,

    pub model_id: Uuid,

    pub name: String,

    pub inserted_at: UtcDateTime,

    pub updated_at: UtcDateTime,
}

pub enum AttributeKind {
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
