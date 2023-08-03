use tonic::{Request, Response, Status};

pub mod proto {
    pub mod temple {
        tonic::include_proto!("proto.temple.v1"); // The string specified here must match the proto package name
    }

    pub mod gymnasium {
        tonic::include_proto!("proto.gymnasium.v1");

        pub mod dimensions {
            tonic::include_proto!("proto.gymnasium.v1.dimensions");
        }
    }
}

#[derive(Debug, Default)]
pub struct Projects {}

#[tonic::async_trait]
impl proto::temple::projects_server::Projects for Projects {
    async fn list_projects(
        &self,
        request: Request<proto::temple::ListProjectsRequest>, // Accept request of type HelloRequest
    ) -> Result<Response<proto::temple::ListProjectsResponse>, Status> {
        // Return an instance of type HelloReply
        println!("Got a request: {:?}", request);

        let mut client =
            proto::gymnasium::dimensions_client::DimensionsClient::connect("http://localhost:50052")
                .await
                .map_err(|err| {
                    dbg!(err);

                    Status::internal("can't connect to datastore")
                })?;

        let response = client.select_dimension_records(proto::gymnasium::SelectDimensionRecordsRequest{
            parameters: Some(
                proto::gymnasium::select_dimension_records_request::Parameters::ProjectParameters(
                    proto::gymnasium::ProjectParameters {}
                )
            ),
        }).await.map_err(|_err| {
            Status::internal("can't connect to datastore 2")
        })?
        .into_inner();

        if response.records.is_none() {
            return Err(Status::internal("something went wrong"));
        }

        let projects = match response.records.unwrap() {
            proto::gymnasium::select_dimension_records_response::Records::ProjectRecords(
                catalogue,
            ) => catalogue
                .records
                .into_iter()
                .map(|record| proto::temple::Project {
                    id: record.id,
                    name: record.name,
                    description: record.description,
                    create_time: record.create_time,
                })
                .collect::<Vec<proto::temple::Project>>(),
        };

        Ok(Response::new(proto::temple::ListProjectsResponse {
            projects,
        }))
    }
}
