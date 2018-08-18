defmodule Dsmr.Parser do
  use Combine

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    {:ok, %{}}
  end

  def parse_telegram(telegram), do: Combine.parse(telegram, parser())

  defp parser() do
    sequence([
      skip_many(newline()),
      header(),
      ignore(newline()),
      ignore(newline()),
      version(),
      ignore(newline()),
      timestamp(),
      ignore(newline()),
      identifier(),
      ignore(newline()),
      electricity_delivered1(),
      ignore(newline()),
      electricity_delivered2(),
      ignore(newline()),
      electricity_received1(),
      ignore(newline()),
      electricity_received2(),
      ignore(newline()),
      tariff_indicator(),
      ignore(newline()),
      power_delivered(),
      ignore(newline()),
      power_received(),
      ignore(newline())
    ])
  end

  defp header() do
    label(
      take_while(fn
        c when c in [?\r, ?\n] -> false
        _ -> true
      end),
      "header"
    )
  end

  defp version() do
    sequence([
      ignore(string("1-3:0.2.8(")),
      label(integer(), "version"),
      ignore(char(")"))
    ])
  end

  defp timestamp() do
    sequence([
      ignore(string("0-0:1.0.0(")),
      label(times(digit(), 2), "year"),
      label(times(digit(), 2), "month"),
      label(times(digit(), 2), "day"),
      label(times(digit(), 2), "hours"),
      label(times(digit(), 2), "minutes"),
      label(times(digit(), 2), "seconds"),
      label(either(char("W"), char("S")), "daylight"),
      ignore(char(")"))
    ])
  end

  defp identifier() do
    sequence([
      ignore(string("0-0:96.1.1(")),
      label(
        take_while(fn
          c when c in '0123456789ABCDEF' -> true
          _ -> false
        end),
        "identifier"
      ),
      ignore(char(")"))
    ])
  end

  defp electricity_delivered1() do
    sequence([
      ignore(string("1-0:1.8.1(")),
      label(float(), "electricity_kwh"),
      ignore(string("*kWh)"))
    ])
  end

  defp electricity_delivered2() do
    sequence([
      ignore(string("1-0:1.8.2(")),
      label(float(), "electricity_kwh"),
      ignore(string("*kWh)"))
    ])
  end

  defp electricity_received1() do
    sequence([
      ignore(string("1-0:2.8.1(")),
      label(float(), "electricity_kwh"),
      ignore(string("*kWh)"))
    ])
  end

  defp electricity_received2() do
    sequence([
      ignore(string("1-0:2.8.2(")),
      label(float(), "electricity_kwh"),
      ignore(string("*kWh)"))
    ])
  end

  defp tariff_indicator() do
    sequence([
      ignore(string("0-0:96.14.0(")),
      label(integer(), "tariff_indicator"),
      ignore(string(")"))
    ])
  end

  defp power_delivered() do
    sequence([
      ignore(string("1-0:1.7.0(")),
      label(float(), "electricity_kw"),
      ignore(string("*kW)"))
    ])
  end

  defp power_received() do
    sequence([
      ignore(string("1-0:2.7.0(")),
      label(float(), "electricity_kw"),
      ignore(string("*kW)"))
    ])
  end

end
