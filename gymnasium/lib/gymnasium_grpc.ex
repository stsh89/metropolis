defmodule Proto.Gymnasium.Endpoint do
  use GRPC.Endpoint

  intercept GRPC.Server.Interceptors.Logger
  run(Proto.Gymnasium.V1.Dimensions.Server)
end

defmodule Proto.Gymnasium.V1.Dimensions.Server do
  use GRPC.Server, service: Proto.Gymnasium.V1.Dimensions.Service

  def select_dimension_records(
        %Proto.Gymnasium.V1.SelectDimensionRecordsRequest{
          parameters: {:project_parameters, _parameters}
        },
        _stream
      ) do
    project_records =
      Gymnasium.Projects.list_projects()
      |> Enum.map(fn project ->
        %Proto.Gymnasium.V1.Dimensions.Project{
          id: project.id,
          name: project.name,
          description: project.description,
          create_time: to_proto_timestamp(project.inserted_at)
        }
      end)

    %Proto.Gymnasium.V1.SelectDimensionRecordsResponse{
      records: {:project_records, %{records: project_records}}
    }
  end

  defp to_proto_timestamp(date_time) do
    nanos = DateTime.to_unix(date_time, :nanosecond)
    seconds = DateTime.to_unix(date_time, :second)

    %Google.Protobuf.Timestamp{
      seconds: seconds,
      nanos: nanos - seconds * 1_000_000_000
    }
  end

  defp from_proto_timestamp(%Google.Protobuf.Timestamp{
         seconds: seconds,
         nanos: nanos
       }) do
    DateTime.from_unix!(seconds * 1_000_000_000 + nanos, :nanosecond)
  end
end
