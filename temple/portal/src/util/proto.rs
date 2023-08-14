use chrono::TimeZone;
use foundation::{UtcDateTime, Uuid};
use prost_types::Timestamp;
use tonic::Status;

pub fn uuid_from_proto_string(id: &str, argument_name: &str) -> Result<Uuid, Status> {
    Uuid::parse_str(id).map_err(|_err| Status::invalid_argument(argument_name))
}

// pub fn to_proto_timestamp(datetime: UtcDateTime) -> Timestamp {
//     prost_types::Timestamp {
//         seconds: datetime.timestamp(),
//         nanos: datetime.timestamp_subsec_nanos() as i32,
//     }
// }

pub fn from_proto_timestamp(
    timestamp: Timestamp,
    argument_name: &str,
) -> Result<UtcDateTime, Status> {
    let Ok(nanos) = timestamp
        .nanos
        .try_into() else {
            return Err(Status::invalid_argument(argument_name));
        };

    match chrono::Utc.timestamp_opt(timestamp.seconds, nanos) {
        chrono::LocalResult::Single(datetime) => Ok(datetime),
        _ => Err(Status::invalid_argument(argument_name)),
    }
}
