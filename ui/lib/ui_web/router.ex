defmodule UiWeb.Router do
  use UiWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", UiWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  scope "/api/v1", UiWeb do
    pipe_through(:api)

    get("/readings", ReadingController, :index)
    get("/readings/last", ReadingController, :last)
  end
end
