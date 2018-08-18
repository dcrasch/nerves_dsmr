require Logger

defmodule UiWeb.Channels.TelegramChannel do
  use Phoenix.Channel

  def join("telegram:electricity", _params, socket) do
    Logger.info("Joining telegram electricity")
    {:ok, socket}
  end

  def handle_in("telegram", msg, socket) do
    broadcast!(socket, "telegram", msg)
    {:reply, :ok, socket}
  end
end
