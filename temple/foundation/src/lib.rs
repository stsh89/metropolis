//! The main module, which is a place for the definitions of the core entities
//! and operations.

pub mod attribute_type;
pub mod datastore;
pub mod model;
pub mod project;

mod diagram;
mod result;
mod util;

mod tests;

pub use result::{FoundationError, FoundationErrorCode, FoundationResult};

pub type UtcDateTime = chrono::DateTime<chrono::Utc>;
pub type Uuid = uuid::Uuid;
pub type Utc = chrono::Utc;

// pub fn add(left: usize, right: usize) -> usize {
//     left + right
// }

// #[cfg(test)]
// mod tests {
//     use super::*;

//     #[test]
//     fn it_works() {
//         let result = add(2, 2);
//         assert_eq!(result, 4);
//     }
// }
