defmodule UiWeb.ReadingView do
  use UiWeb, :view
  alias UiWeb.ReadingView

  def render("index.json", %{readings: readings}) do
    %{data: render_many(readings, ReadingView, "reading.json")}
  end

  def render("show.json", %{reading: reading}) do
    %{data: render_one(reading, ReadingView, "reading.json")}
  end

  def render("reading.json", %{reading: reading}) do
    %{
      id: reading.id,
      timestamp: reading.timestamp,
      electricity_delivered_1: reading.electricity_delivered_1,
      electricity_delivered_2: reading.electricity_delivered_2,
      electricity_returned_1: reading.electricity_returned_1,
      electricity_returned_2: reading.electricity_returned_2
    }
  end
end
