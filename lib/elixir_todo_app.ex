defmodule ElixirTodoApp do
  alias ElixirTodoApp.Todo
  alias ElixirTodoApp.Repo
  def start do
    IO.puts ("Hello, Waht do you want to do?")
    choice = IO.gets("1. Add a todo\n2. Exit\n") |> String.trim_trailing |> String.to_integer

    case choice do
      1 ->
        add_todo()
        start()

      2 ->
        IO.puts("Goodbye")
    end
  end

  def show_todos do 
    todos = Repo.all(Todo) 
    IO.puts("----------------------------------------")

    Enum.each(todos, fn(todo) ->
      IO.puts("#{todo.title} by #{todo.user} - on hold: #{todo.on_hold}")  
      end
    )
    IO.puts("----------------------------------------")
  end

  def add_todo do
    IO.puts("Adding a todo")
    title = IO.gets("What do you want to get accomplished?\n") |> String.trim_trailing
    user = IO.gets("Your name please?\n") |> String.trim_trailing
    on_hold = IO.gets("Do you want to keep this task on hold for future?(yes) or (no)\n") |> String.trim_trailing

    # Create a new todo
    todo = %Todo{title: title, user: user, completed: false, on_hold: on_hold == "yes"}
    changeset = Todo.changeset(todo, %{})

    case Repo.insert(changeset) do
      {:ok, todo} ->
        IO.puts("#{todo.title} by #{todo.user} created successfuly.")
        
        show_todos()

      {:error, _} ->
        IO.puts("Please enter valid values")
        add_todo()
    end
  end

end
