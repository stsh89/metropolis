defmodule GymnasiumGrpc.Helpers do
  def to_proto_timestamp(date_time) do
    nanos = DateTime.to_unix(date_time, :nanosecond)
    seconds = DateTime.to_unix(date_time, :second)

    %Google.Protobuf.Timestamp{
      seconds: seconds,
      nanos: nanos - seconds * 1_000_000_000
    }
  end

  def from_proto_timestamp(%Google.Protobuf.Timestamp{
        seconds: seconds,
        nanos: nanos
      }) do
    DateTime.from_unix!(seconds * 1_000_000_000 + nanos, :nanosecond)
  end
end
