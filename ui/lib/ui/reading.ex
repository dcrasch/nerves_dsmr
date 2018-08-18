defmodule Ui.Reading do
  use Ecto.Schema
  import Ecto.Changeset

  schema "readings" do
    field(:electricity_delivered_1, :float)
    field(:electricity_delivered_2, :float)
    field(:electricity_returned_1, :float)
    field(:electricity_returned_2, :float)
    field(:timestamp, :naive_datetime)

    timestamps()
  end

  @doc false
  def changeset(reading, attrs) do
    reading
    |> cast(attrs, [
      :timestamp,
      :electricity_delivered_1,
      :electricity_delivered_2,
      :electricity_returned_1,
      :electricity_returned_2
    ])
    |> validate_required([
      :timestamp,
      :electricity_delivered_1,
      :electricity_delivered_2,
      :electricity_returned_1,
      :electricity_returned_2
    ])
  end
end
