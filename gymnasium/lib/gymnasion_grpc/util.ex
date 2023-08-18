defmodule GymnasiumGrpc.Util do
  @doc """
  Convert datetime to Google timestamp.

  ## Examples

      iex> dt = ~U[2023-08-18 13:18:39.803804Z]
      iex> Util.to_proto_timestamp(dt)
      %Google.Protobuf.Timestamp{
        seconds: 1692364719,
        nanos: 803804000
      }

  """
  @spec to_proto_timestamp(Calendar.datetime()) :: %Google.Protobuf.Timestamp{}
  def to_proto_timestamp(%DateTime{} = date_time) do
    nanos = DateTime.to_unix(date_time, :nanosecond)
    seconds = DateTime.to_unix(date_time, :second)

    %Google.Protobuf.Timestamp{
      seconds: seconds,
      nanos: nanos - seconds * 1_000_000_000
    }
  end

  @doc """
  Convert Google timestamp to datetime

  ## Examples

      iex> timestamp = %Google.Protobuf.Timestamp{
      ...>   seconds: 1692364719,
      ...>   nanos: 803804000
      ...> }
      iex> Util.from_proto_timestamp(timestamp)
      ~U[2023-08-18 13:18:39.803804Z]

  """
  @spec from_proto_timestamp(%Google.Protobuf.Timestamp{}) :: Calendar.datetime()
  def from_proto_timestamp(%Google.Protobuf.Timestamp{seconds: seconds, nanos: nanos}) do
    DateTime.from_unix!(seconds * 1_000_000_000 + nanos, :nanosecond)
  end
end
