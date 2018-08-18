defmodule Dsmr.MixProject do
  use Mix.Project

  def project do
    [
      app: :dsmr,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Dsmr, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nerves_uart, "~> 1.2.0"},
      {:combine, "~> 0.10.0"},
      {:gen_stage, "~> 0.13.1"}
    ]
  end
end
