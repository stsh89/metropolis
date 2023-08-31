use crate::{attribute_type::AttributeTypeRecord, Utc, UtcDateTime, Uuid};

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

#[derive(Clone)]
pub struct Attribute {
    pub id: Uuid,

    pub model_id: Uuid,

    pub description: String,

    pub r#type: AttributeTypeRecord,

    pub name: String,

    pub inserted_at: UtcDateTime,

    pub updated_at: UtcDateTime,
}

#[derive(Clone, Default)]
pub struct Association {
    pub id: Uuid,

    pub model_id: Uuid,

    pub associated_model: Model,

    pub description: String,

    pub kind: AssociationKind,

    pub name: String,

    pub inserted_at: UtcDateTime,

    pub updated_at: UtcDateTime,
}

#[derive(Clone, Default)]
pub enum AssociationKind {
    #[default]
    BelongsTo,

    HasOne,

    HasMany,
}

#[derive(Clone)]
pub struct ModelOverview {
    pub model: Model,

    pub attributes: Vec<Attribute>,

    pub associations: Vec<Association>,
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
            r#type: Default::default(),
            name: Default::default(),
            inserted_at: now,
            updated_at: now,
        }
    }
}
