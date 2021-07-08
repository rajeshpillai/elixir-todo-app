defmodule ElixirTodoApp.Todo  do
  use Ecto.Schema

  schema "todos" do
    field :title, :string
    field :user, :string
    field :completed, :boolean, default: :false
    field :on_hold, :boolean, default: :false

  end

  def changeset(todo, params \\ %{}) do
    todo 
      |> Ecto.Changeset.cast(params, [:title, :user, :completed, :on_hold])
      |> Ecto.Changeset.validate_required([:title, :user])
  end

end
