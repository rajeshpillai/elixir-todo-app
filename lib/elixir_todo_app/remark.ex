defmodule ElixirTodoApp.Remark do
  use Ecto.Schema 

  schema "remarks" do
    field :body, :string 
    belongs_to :todo, ElixirTodoApp.Todo
  end

  def changeset(remark, params \\ %{}) do
    remark 
    |> Ecto.Changeset.cast(params, [:body, :todo_id])
    |> Ecto.Changeset.validate_required([:body])
  end
end