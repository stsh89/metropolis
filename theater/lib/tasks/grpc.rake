namespace :grpc do
  task :build do
    puts 'start building gRPC libs'

    `grpc_tools_ruby_protoc -I ../proto --ruby_out=lib --grpc_out=lib ../proto/projects.proto`

    puts 'end building gRPC libs'
  end
end
