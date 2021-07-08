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

  def add_todo do
    IO.puts("Adding a todo")
    title = IO.gets("What do you want to accomplish today?\n") |> String.trim_trailing
    user = IO.gets("Your name please?\n") |> String.trim_trailing

    # Create a new todo
    todo =%Todo{title: title, user: user, completed: false}

    case Repo.insert(todo) do
      {:ok, todo} ->
        IO.puts("#{todo.title} by #{todo.user} created successfuly.")
        todos = Repo.all(Todo) 
        IO.puts("----------------------------")
        Enum.each(todos, fn(todo) ->
          IO.puts("#{todo.title} by #{todo.user}")  
        end
        )
        IO.puts("----------------------------")
    end
  end

end
