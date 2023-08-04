namespace :protobuf do
  task :compile do
    puts 'start compiling protobuf libs'

    `grpc_tools_ruby_protoc --proto_path ../protobuf --ruby_out=lib --grpc_out=lib ../protobuf/proto/temple/v1/projects.proto`

    puts 'end compiling protobuf libs'
  end
end
