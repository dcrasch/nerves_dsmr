require Logger

defmodule Dsmr.Port.Reader do
  use GenServer

  def start_link(port_name, opts \\ []) do
    GenServer.start_link(__MODULE__, {port_name}, opts)
  end

  defmodule State do
    defstruct dsmr_data: nil,
              pid: nil,
              port_name: nil
  end

  def init({port_name}) do
    {:ok, uart_pid} = Nerves.UART.start_link()

    with :ok <- Nerves.UART.configure(uart_pid, framing: {Dsmr.Port.Framing.Telegram, []}),
         :ok <- Nerves.UART.open(uart_pid, port_name, speed: 115_200, active: true) do
      {:ok, %State{dsmr_data: nil, pid: uart_pid, port_name: port_name}}
    else
      err -> err
    end
  end

  def handle_info({:nerves_uart, port_name, data}, %State{port_name: port_name} = state) do
    Logger.debug("Serial data: #{inspect(data)}")
    telegram_parsed = Dsmr.Parser.parse_telegram(data)
    telegram = process_telegram(telegram_parsed)
    Dsmr.Broadcaster.async_notify(telegram)
    {:noreply, %{state | dsmr_data: telegram}}
  end

  def process_telegram([[h, [v], t, [i], [e1], [e2], [r1], [r2],
                         [ti], [pd], [pr]]]) do
    %{
      header: List.to_string(h),
      version: v,
      timestamp: decode_timestamp(t),
      identifier: Base.decode16!(to_string(i)),
      electricity_delivered_1: e1,
      electricity_delivered_2: e2,
      electricity_returned_1: r1,
      electricity_returned_2: r2,
      tariff_indicator: ti,
      power_delivered: pd,
      power_returned: pr,
    }
  end

  defp decode_timestamp([[y1, y2], [m1, m2], [d1, d2],
                         [h1, h2], [mi1, mi2], [s1, s2], _]) do
    {:ok, n} =
      NaiveDateTime.new(
        2000 + y1 * 10 + y2,
        m1 * 10 + m2,
        d1 * 10 + d2,
        h1 * 10 + h2,
        mi1 * 10 + mi2,
        s1 * 10 + s2
      )

    n
  end

  def terminate(_reason, state) do
    Nerves.UART.close(state.pid)
    Nerves.UART.stop(state.pid)
  end
end
