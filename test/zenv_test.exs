defmodule ZenvTest do
  use ExUnit.Case
  doctest Zenv

  test "greets the world" do
    assert Zenv.hello() == :world
  end
end
