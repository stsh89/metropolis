# frozen_string_literal: true
# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: projects.proto

require 'google/protobuf'

require 'google/protobuf/timestamp_pb'


descriptor_data = "\n\x0eprojects.proto\x12\x08projects\x1a\x1fgoogle/protobuf/timestamp.proto\"\x15\n\x13ListProjectsRequest\";\n\x14ListProjectsResponse\x12#\n\x08projects\x18\x01 \x03(\x0b\x32\x11.projects.Project\"n\n\x07Project\x12\n\n\x02id\x18\x01 \x01(\t\x12\x0c\n\x04name\x18\x02 \x01(\t\x12\x13\n\x0b\x64\x65scription\x18\x03 \x01(\t\x12\x34\n\x10\x63reate_timestamp\x18\x04 \x01(\x0b\x32\x1a.google.protobuf.Timestamp2`\n\x0fProjectsService\x12M\n\x0cListProjects\x12\x1d.projects.ListProjectsRequest\x1a\x1e.projects.ListProjectsResponseb\x06proto3"

pool = Google::Protobuf::DescriptorPool.generated_pool

begin
  pool.add_serialized_file(descriptor_data)
rescue TypeError => e
  # Compatibility code: will be removed in the next major version.
  require 'google/protobuf/descriptor_pb'
  parsed = Google::Protobuf::FileDescriptorProto.decode(descriptor_data)
  parsed.clear_dependency
  serialized = parsed.class.encode(parsed)
  file = pool.add_serialized_file(serialized)
  warn "Warning: Protobuf detected an import path issue while loading generated file #{__FILE__}"
  imports = [
    ["google.protobuf.Timestamp", "google/protobuf/timestamp.proto"],
  ]
  imports.each do |type_name, expected_filename|
    import_file = pool.lookup(type_name).file_descriptor
    if import_file.name != expected_filename
      warn "- #{file.name} imports #{expected_filename}, but that import was loaded as #{import_file.name}"
    end
  end
  warn "Each proto file must use a consistent fully-qualified name."
  warn "This will become an error in the next major version."
end

module Projects
  ListProjectsRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("projects.ListProjectsRequest").msgclass
  ListProjectsResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("projects.ListProjectsResponse").msgclass
  Project = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("projects.Project").msgclass
end
