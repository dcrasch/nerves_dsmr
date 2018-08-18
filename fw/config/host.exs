use Mix.Config

config :ui, Ui.Repo,
  adapter: Sqlite.Ecto2,
  database: "#{Mix.env()}.sqlite3"
