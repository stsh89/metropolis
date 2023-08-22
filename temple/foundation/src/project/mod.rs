pub mod archive;
pub mod create;
pub mod delete;
pub mod get;
pub mod list;
pub mod list_archived;
pub mod rename;
pub mod restore;

use crate::{datastore, util, FoundationResult};

#[async_trait::async_trait]
pub trait CreateProjectRecord {
    async fn create_project_record(
        &self,
        project: Project,
    ) -> FoundationResult<datastore::project::Project>;
}

#[async_trait::async_trait]
pub trait GetProjectRecord {
    async fn get_project_record(&self, slug: &str)
        -> FoundationResult<datastore::project::Project>;
}

#[async_trait::async_trait]
pub trait ListProjectRecords {
    async fn list_project_records(
        &self,
        filters: ListProjectRecordFilters,
    ) -> FoundationResult<Vec<datastore::project::Project>>;
}

#[async_trait::async_trait]
pub trait DeleteProjectRecord {
    async fn delete_project_record(
        &self,
        project_record: datastore::project::Project,
    ) -> FoundationResult<()>;
}

#[async_trait::async_trait]
pub trait RenameProjectRecord {
    async fn rename_project_record(
        &self,
        project_record: datastore::project::Project,
    ) -> FoundationResult<datastore::project::Project>;
}

#[async_trait::async_trait]
pub trait RestoreProjectRecord {
    async fn restore_project_record(
        &self,
        project_record: datastore::project::Project,
    ) -> FoundationResult<()>;
}

#[async_trait::async_trait]
pub trait ArchiveProjectRecord {
    async fn archive_project_record(
        &self,
        project_record: datastore::project::Project,
    ) -> FoundationResult<()>;
}

pub struct ListProjectRecordFilters {
    pub archive_filter: ListProjectRecordFilterArchive,
}

pub enum ListProjectRecordFilterArchive {
    Any,

    ArchivedOnly,

    NotArchivedOnly,
}

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
