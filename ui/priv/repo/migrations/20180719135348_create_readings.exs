defmodule Ui.Repo.Migrations.CreateReadings do
  use Ecto.Migration

  def change do
    create table(:readings) do
      add :timestamp, :naive_datetime
      add :electricity_delivered_1, :float
      add :electricity_delivered_2, :float
      add :electricity_returned_1, :float
      add :electricity_returned_2, :float

      timestamps()
    end

  end
end
