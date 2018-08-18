defmodule Ui.Readings do
  import Ecto.Query, warn: false
  alias Ui.{Repo, Reading}

  def list_readings do
    Reading
    |> Repo.all
  end

  def list_lastreadings(limit \\ 3600) do
    start_id = Repo.one(from p in Reading, select: max(p.id)) - 604800
    Repo.all(from p in Reading, where:
      (p.id >= ^start_id and
      fragment("?%14400",p.id)==0),
        order_by: [asc: p.id])
  end

  def get_reading!(id), do: Repo.get!(Reading, id)

  def create_reading(attrs \\ %{}) do
    %Reading{}
    |> Reading.changeset(attrs)
    |> Repo.insert()
  end

  def update_reading(%Reading{} = reading, attrs) do
    reading
    |> Reading.changeset(attrs)
    |> Repo.update()
  end
end
