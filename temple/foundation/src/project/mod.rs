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
    use crate::tests::project_record_fixture;

    #[test]
    fn it_converts_from_record() {
        let project_record = project_record_fixture(Default::default());

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
