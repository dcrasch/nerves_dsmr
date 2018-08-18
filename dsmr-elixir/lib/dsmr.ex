require Logger

defmodule Dsmr do
  @moduledoc false

  use Application, Super

  def start(_type, _args) do
    import Supervisor.Spec
    Logger.info("Starting Dsmr OTP Application...")
    port_name = Application.get_env(:dsmr, :port_name)

    children = [
      worker(Dsmr.Port.Reader, [port_name]),
      worker(Dsmr.Broadcaster, [])
    ]

    opts = [strategy: :one_for_one, name: Dsmr.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
