# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :ui, UiWeb.Endpoint,
  url: [host: "localhost"],
  http: [port: 8000],
  secret_key_base: "5Isd0gahJy4qDVoVsRDo3xV5RzbgyrwTzGomYiaBEgVTZJjSql21ba8dbvCSsAEN",
  render_errors: [view: UiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Ui.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Configure Ecto
config :ui,
  ecto_repos: [Ui.Repo]

config :ui, Ui.Repo,
  adapter: Sqlite.Ecto2,
  database: "#{Mix.env()}.sqlite3"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
