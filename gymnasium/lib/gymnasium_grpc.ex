defmodule Proto.Gymnasium.Endpoint do
  use GRPC.Endpoint

  intercept GRPC.Server.Interceptors.Logger
  run(Proto.Gymnasium.V1.Dimensions.Server)
end

defmodule Proto.Gymnasium.V1.Dimensions.Server do
  use GRPC.Server, service: Proto.Gymnasium.V1.Dimensions.Service

  def select_dimension_records(request, _stream) do
    case request.record_parameters do
      {:project_record_parameters, parameters} ->
        GymnasiumGrpc.Dimensions.Project.select(parameters)

      _ ->
        raise GRPC.RPCError, status: :invalid_argument
    end
  end

  def store_dimension_record(request, _stream) do
    case request.record do
      {:project_record, record} ->
        GymnasiumGrpc.Dimensions.Project.store(record)

      _ ->
        raise GRPC.RPCError, status: :invalid_argument
    end
  end

  def find_dimension_record(request, _stream) do
    case request.id do
      {:project_record_slug, slug} ->
        GymnasiumGrpc.Dimensions.Project.find(slug)

      {:project_record_id, id} ->
        GymnasiumGrpc.Dimensions.Project.get(id)

      _ ->
        raise GRPC.RPCError, status: :invalid_argument
    end
  end

  def remove_dimension_record(request, _stream) do
    case request.id do
      {:project_record_id, id} ->
        GymnasiumGrpc.Dimensions.Project.remove(id)

      _ ->
        raise GRPC.RPCError, status: :invalid_argument
    end
  end
end
