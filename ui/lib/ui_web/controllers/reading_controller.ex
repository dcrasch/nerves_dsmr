defmodule UiWeb.ReadingController do
  use UiWeb, :controller

  def index(conn, _parms) do
    readings = Ui.Readings.list_readings()
    render(conn, "index.json", readings: readings)
  end

  def last(conn, _params) do
    readings = Ui.Readings.list_lastreadings()
    render(conn, "index.json", readings: readings)
  end

end
