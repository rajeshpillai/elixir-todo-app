defmodule ElixirTodoApp.Repo.Migrations.CreateRemarks do
  use Ecto.Migration

  def change do
    create table (:remarks) do
      add :body, :text 
      add :todo_id, references(:todos, on_delete: :delete_all)
    end
  end
end
