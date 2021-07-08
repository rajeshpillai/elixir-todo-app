defmodule ElixirTodoAppTest do
  use ExUnit.Case
  doctest ElixirTodoApp

  test "greets the world" do
    assert ElixirTodoApp.hello() == :world
  end
end
