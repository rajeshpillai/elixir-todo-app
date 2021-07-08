defmodule ElixirTodoApp.Todo  do
  use Ecto.Schema

  schema "todos" do
    field :title, :string
    field :user, :string
    field :completed, :boolean

  end

  def changeset(todo, params \\ %{}) do
    todo 
      |> Ecto.Changeset.cast(params, [:title, :user, :completed])
      |> Ecto.Changeset.validate_required([:title, :user])
  end

end
