defmodule Mix.Tasks.Protobuf.Compile do
  @moduledoc """
      The task for generating Elixir code from proto definitions:
      `mix help protobuf.compile`
  """
  use Mix.Task

  @shortdoc "Generates Elixir protobuf definitions"
  def run(_) do
    compile_proto_definitions()
  end

  defp compile_proto_definitions do
    IO.puts("Compiling proto definitions:")

    files = [
      "dimensions.proto",
      "dimensions/model.proto",
      "dimensions/project.proto",
      "projects/projects.proto",
    ]

    for file <- files do
      path = "../protobuf/proto/gymnasium/v1/#{file}"

      System.cmd("protoc", [
        "--proto_path=../protobuf",
        "--elixir_out=plugins=grpc:./lib",
        path
      ])

      IO.puts("#{path}")
    end
  end
end
