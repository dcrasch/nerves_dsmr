use Mix.Config

config :logger, backends: [RingLogger]

config :ui, UiWeb.Endpoint,
  # used for csrf
  url: [host: "powerpi"],
  http: [port: 80],
  secret_key_base: "2#############1##############",
  root: Path.dirname(__DIR__),
  server: true,
  render_errors: [view: UiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Nerves.PubSub, adapter: Phoenix.PubSub.PG2],
  code_reloader: false

config :dsmr,
  port_name: "/dev/ttyUSB0"

config :ui, Ui.Repo,
  adapter: Sqlite.Ecto2,
  database: "/root/#{Mix.env()}.sqlite3"
