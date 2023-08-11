# frozen_string_literal: true
# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: proto/temple/v1/projects.proto

require 'google/protobuf'

require 'google/protobuf/timestamp_pb'


descriptor_data = "\n\x1eproto/temple/v1/projects.proto\x12\x0fproto.temple.v1\x1a\x1fgoogle/protobuf/timestamp.proto\"\x19\n\x17ShowcaseProjectsRequest\"F\n\x18ShowcaseProjectsResponse\x12*\n\x08projects\x18\x01 \x03(\x0b\x32\x18.proto.temple.v1.Project\"=\n\x18InitializeProjectRequest\x12\x0c\n\x04name\x18\x01 \x01(\t\x12\x13\n\x0b\x64\x65scription\x18\x02 \x01(\t\"F\n\x19InitializeProjectResponse\x12)\n\x07project\x18\x01 \x01(\x0b\x32\x18.proto.temple.v1.Project\"0\n\x14RenameProjectRequest\x12\n\n\x02id\x18\x01 \x01(\t\x12\x0c\n\x04name\x18\x02 \x01(\t\"B\n\x15RenameProjectResponse\x12)\n\x07project\x18\x01 \x01(\x0b\x32\x18.proto.temple.v1.Project\"*\n\x1a\x43heckProjectDetailsRequest\x12\x0c\n\x04slug\x18\x01 \x01(\t\"H\n\x1b\x43heckProjectDetailsResponse\x12)\n\x07project\x18\x01 \x01(\x0b\x32\x18.proto.temple.v1.Project\"#\n\x15\x41rchiveProjectRequest\x12\n\n\x02id\x18\x01 \x01(\t\"C\n\x16\x41rchiveProjectResponse\x12)\n\x07project\x18\x01 \x01(\x0b\x32\x18.proto.temple.v1.Project\"#\n\x15RecoverProjectRequest\x12\n\n\x02id\x18\x01 \x01(\t\"C\n\x16RecoverProjectResponse\x12)\n\x07project\x18\x01 \x01(\x0b\x32\x18.proto.temple.v1.Project\" \n\x1eInquireArchivedProjectsRequest\"M\n\x1fInquireArchivedProjectsResponse\x12*\n\x08projects\x18\x01 \x03(\x0b\x32\x18.proto.temple.v1.Project\"\"\n\x14\x44\x65leteProjectRequest\x12\n\n\x02id\x18\x01 \x01(\t\"\x17\n\x15\x44\x65leteProjectResponse\"w\n\x07Project\x12\n\n\x02id\x18\x01 \x01(\t\x12\x0c\n\x04name\x18\x02 \x01(\t\x12\x0c\n\x04slug\x18\x03 \x01(\t\x12\x13\n\x0b\x64\x65scription\x18\x04 \x01(\t\x12/\n\x0b\x63reate_time\x18\x05 \x01(\x0b\x32\x1a.google.protobuf.Timestamp2\xd5\x06\n\x08Projects\x12g\n\x10ShowcaseProjects\x12(.proto.temple.v1.ShowcaseProjectsRequest\x1a).proto.temple.v1.ShowcaseProjectsResponse\x12j\n\x11InitializeProject\x12).proto.temple.v1.InitializeProjectRequest\x1a*.proto.temple.v1.InitializeProjectResponse\x12^\n\rRenameProject\x12%.proto.temple.v1.RenameProjectRequest\x1a&.proto.temple.v1.RenameProjectResponse\x12p\n\x13\x43heckProjectDetails\x12+.proto.temple.v1.CheckProjectDetailsRequest\x1a,.proto.temple.v1.CheckProjectDetailsResponse\x12\x61\n\x0e\x41rchiveProject\x12&.proto.temple.v1.ArchiveProjectRequest\x1a\'.proto.temple.v1.ArchiveProjectResponse\x12\x61\n\x0eRecoverProject\x12&.proto.temple.v1.RecoverProjectRequest\x1a\'.proto.temple.v1.RecoverProjectResponse\x12|\n\x17InquireArchivedProjects\x12/.proto.temple.v1.InquireArchivedProjectsRequest\x1a\x30.proto.temple.v1.InquireArchivedProjectsResponse\x12^\n\rDeleteProject\x12%.proto.temple.v1.DeleteProjectRequest\x1a&.proto.temple.v1.DeleteProjectResponseb\x06proto3"

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

module Proto
  module Temple
    module V1
      ShowcaseProjectsRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("proto.temple.v1.ShowcaseProjectsRequest").msgclass
      ShowcaseProjectsResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("proto.temple.v1.ShowcaseProjectsResponse").msgclass
      InitializeProjectRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("proto.temple.v1.InitializeProjectRequest").msgclass
      InitializeProjectResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("proto.temple.v1.InitializeProjectResponse").msgclass
      RenameProjectRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("proto.temple.v1.RenameProjectRequest").msgclass
      RenameProjectResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("proto.temple.v1.RenameProjectResponse").msgclass
      CheckProjectDetailsRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("proto.temple.v1.CheckProjectDetailsRequest").msgclass
      CheckProjectDetailsResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("proto.temple.v1.CheckProjectDetailsResponse").msgclass
      ArchiveProjectRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("proto.temple.v1.ArchiveProjectRequest").msgclass
      ArchiveProjectResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("proto.temple.v1.ArchiveProjectResponse").msgclass
      RecoverProjectRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("proto.temple.v1.RecoverProjectRequest").msgclass
      RecoverProjectResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("proto.temple.v1.RecoverProjectResponse").msgclass
      InquireArchivedProjectsRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("proto.temple.v1.InquireArchivedProjectsRequest").msgclass
      InquireArchivedProjectsResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("proto.temple.v1.InquireArchivedProjectsResponse").msgclass
      DeleteProjectRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("proto.temple.v1.DeleteProjectRequest").msgclass
      DeleteProjectResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("proto.temple.v1.DeleteProjectResponse").msgclass
      Project = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("proto.temple.v1.Project").msgclass
    end
  end
end