namespace :protobuf do
  task :compile do
    `grpc_tools_ruby_protoc --proto_path ../protobuf --ruby_out=lib --grpc_out=lib ../protobuf/proto/temple/v1/projects.proto`

    `grpc_tools_ruby_protoc --proto_path ../protobuf --ruby_out=lib --grpc_out=lib ../protobuf/proto/temple/v1/attribute_types.proto`
  end
end
