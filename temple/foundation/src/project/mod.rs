pub mod archive;
pub mod create;
pub mod delete;
pub mod get;
pub mod list;
pub mod list_archived;
pub mod rename;
pub mod restore;

use crate::{datastore, util};

#[derive(Clone, Debug)]
pub struct Project {
    pub description: Option<String>,

    pub name: String,

    pub slug: String,
}

impl From<datastore::project::Project> for Project {
    fn from(value: datastore::project::Project) -> Self {
        let datastore::project::Project {
            id: _,
            archived_at: _,
            description,
            name,
            slug,
            inserted_at: _,
            updated_at: _,
        } = value;

        Self {
            description: util::string::optional(&description),
            name,
            slug,
        }
    }
}

impl PartialEq for Project {
    fn eq(&self, other: &Self) -> bool {
        self.description == other.description && self.name == other.name && self.slug == other.slug
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{FoundationError, FoundationResult, Uuid};
    use std::collections::HashMap;
    use tokio::sync::RwLock;

    pub struct ProjectRepo {
        pub projects: RwLock<HashMap<Uuid, datastore::project::Project>>,
    }

    impl ProjectRepo {
        pub fn initialize(project_records: Vec<datastore::project::Project>) -> Self {
            let iter: HashMap<Uuid, datastore::project::Project> = project_records
                .into_iter()
                .map(|record| (record.id, record))
                .collect();

            Self {
                projects: RwLock::new(HashMap::from_iter(iter)),
            }
        }

        pub async fn find_project_by_slug(
            &self,
            slug: &str,
        ) -> FoundationResult<datastore::project::Project> {
            let project_records = self.projects.read().await;

            project_records
                .values()
                .find(|project| project.slug == slug)
                .cloned()
                .ok_or(FoundationError::not_found(format!(
                    "no Project with slug: `{slug}`"
                )))
        }

        pub async fn get(&self, id: Uuid) -> FoundationResult<datastore::project::Project> {
            let project_records = self.projects.read().await;

            project_records
                .get(&id)
                .cloned()
                .ok_or(FoundationError::not_found(format!(
                    "no Project with id: `{id}`",
                )))
        }

        pub async fn projects(&self) -> Vec<datastore::project::Project> {
            self.projects.read().await.values().cloned().collect()
        }
    }

    #[test]
    fn it_converts_some_description_from_record() {
        let project_record = datastore::project::Project {
            name: "Book store".to_string(),
            slug: "book-store".to_string(),
            description: "Buy and sell books platform.".to_string(),
            ..Default::default()
        };

        let project: Project = project_record.into();

        assert_eq!(
            project,
            Project {
                name: "Book store".to_string(),
                slug: "book-store".to_string(),
                description: Some("Buy and sell books platform.".to_string()),
            }
        )
    }

    #[test]
    fn it_converts_none_description_from_record() {
        let project_record = datastore::project::Project {
            name: "Book store".to_string(),
            slug: "book-store".to_string(),
            description: "".to_string(),
            ..Default::default()
        };

        let project: Project = project_record.into();

        assert_eq!(
            project,
            Project {
                name: "Book store".to_string(),
                slug: "book-store".to_string(),
                description: None,
            }
        )
    }
}
