defmodule ElixirTodoApp.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  def change do
    create table (:todos) do
      add :title, :string
      add :user, :string
      add :completed, :boolean
    end
  end
end
