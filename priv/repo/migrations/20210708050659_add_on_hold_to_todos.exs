defmodule ElixirTodoApp.Repo.Migrations.AddOnHoldToTodos do
  use Ecto.Migration

  def change do
    alter table(:todos) do 
      add :on_hold, :boolean
    end
  end
end
