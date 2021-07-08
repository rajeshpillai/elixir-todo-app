defmodule ElixirTodoApp.Todo  do
  use Ecto.Schema

  schema "todos" do
    field :title, :string
    field :user, :string
    field :completed, :boolean

  end
end
