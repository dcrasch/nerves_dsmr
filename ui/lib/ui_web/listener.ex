require Logger

defmodule UiWeb.Listener do
  use GenStage

  def start_link do
    Logger.info("Starting Telegram Listener...")
    GenStage.start_link(__MODULE__, :ok)
  end

  ## Server callbacks

  def init(:ok) do
    {:consumer, :ok, subscribe_to: [Dsmr.Broadcaster]}
  end


  def handle_events(events, _from, state) do
    for telegram <- events do
      {:ok, _ } = Ui.Readings.create_reading(telegram)
      UiWeb.Endpoint.broadcast!("telegram:electricity", "update", telegram)
    end
    {:noreply, [], state}
  end

end
