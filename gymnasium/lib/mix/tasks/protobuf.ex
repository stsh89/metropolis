defmodule Mix.Tasks.Protobuf do
  @moduledoc "The task for generating elixir code from proto definitions: `mix help protobuf`"
  use Mix.Task

  @shortdoc "Generates Elixir protobuf definitions"
  def run(_) do
    compile_proto_definitions()
  end

  defp compile_proto_definitions do
    files = [
      "dimensions.proto",
      "dimensions/project.proto"
    ]

    for file <- files do
      System.cmd("protoc", [
        "--proto_path=../protobuf",
        "--elixir_out=plugins=grpc:./lib",
        "../protobuf/proto/gymnasium/v1/#{file}"
      ])
    end
  end
end
