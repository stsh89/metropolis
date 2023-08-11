pub mod datastore;
pub mod project;

mod result;
mod util;

pub use result::{FoundationError, FoundationResult};

type UtcDateTime = chrono::DateTime<chrono::Utc>;
type Uuid = uuid::Uuid;
type Utc = chrono::Utc;

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
