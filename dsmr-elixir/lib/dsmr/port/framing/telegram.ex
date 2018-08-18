defmodule Dsmr.Port.Framing.Telegram do
  @behaviour Nerves.UART.Framing

  defmodule State do
    @moduledoc false

    defstruct max_length: nil, processed: <<>>, in_process: <<>>
  end

  def init(args) do
    max_length = Keyword.get(args, :max_length, 4096)
    state = %State{max_length: max_length}
    {:ok, state}
  end

  def add_framing(data, state) do
    {:ok, data <> state.separator, state}
  end

  def remove_framing(data, state) do
    {new_processed, new_in_process, lines} =
      process_data(
        state.max_length,
        state.processed,
        state.in_process <> data,
        []
      )

    new_state = %{state | processed: new_processed, in_process: new_in_process}
    rc = if buffer_empty?(new_state), do: :ok, else: :in_frame
    {rc, lines, new_state}
  end

  def frame_timeout(state) do
    partial_line = {:partial, state.processed <> state.in_process}
    new_state = %{state | processed: <<>>, in_process: <<>>}
    {:ok, [partial_line], new_state}
  end

  def flush(direction, state) when direction == :receive or direction == :both do
    %{state | processed: <<>>, in_process: <<>>}
  end

  def flush(:transmit, state) do
    state
  end

  def buffer_empty?(%State{processed: <<>>, in_process: <<>>}), do: true
  def buffer_empty?(_state), do: false

  # Handle not enough data case
  defp process_data(_max_length, processed, to_process, lines)
       when byte_size(to_process) < 7 do
    {processed, to_process, lines}
  end

  defp process_data(max_length, processed, to_process, lines) do
    case to_process do
      # Handle checksum
      <<"!", checksum::binary-size(4), "\r\n", rest::binary>> ->
        new_lines = lines ++ [processed]
        process_data(max_length, <<>>, rest, new_lines)

      # Handle line too long case
      to_process
      when byte_size(processed) == max_length and to_process != <<>> ->
        new_lines = lines ++ [{:partial, processed}]
        process_data(max_length, <<>>, to_process, new_lines)

      # Handle next char
      <<next_char::binary-size(1), rest::binary>> ->
        process_data(max_length, processed <> next_char, rest, lines)
    end
  end
end
