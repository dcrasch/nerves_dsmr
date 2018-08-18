defmodule DsmrTest do
  use ExUnit.Case
  doctest Dsmr

  test "greets the world" do
    assert Dsmr.hello() == :world
  end
end
