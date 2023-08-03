defmodule GymnasiumGrpc.Helpers do
  def to_proto_timestamp(date_time = %DateTime{}) do
    nanos = DateTime.to_unix(date_time, :nanosecond)
    seconds = DateTime.to_unix(date_time, :second)

    %Google.Protobuf.Timestamp{
      seconds: seconds,
      nanos: nanos - seconds * 1_000_000_000
    }
  end

  def from_proto_timestamp(timestamp = %Google.Protobuf.Timestamp{}) do
    DateTime.from_unix!(timestamp.seconds * 1_000_000_000 + timestamp.nanos, :nanosecond)
  end
end
