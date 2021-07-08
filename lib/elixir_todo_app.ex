defmodule ElixirTodoApp do
  alias ElixirTodoApp.Todo
  alias ElixirTodoApp.Repo
  alias ElixirTodoApp.Remark

  def start do
    IO.puts ("Hello, What do you want to do?")
    
    input_text = ~S"""
      1. List Todos
      2. Add a todo
      3. Mark todo as completed
      4. Delete todo
      5. Exit
      """

    choice = IO.gets(input_text) |> String.trim_trailing |> String.to_integer

    case choice do
      1 ->
        show_todos()
        start()
      2 ->
        add_todo()
        start()

      3 ->
        mark_todo_as_complete()
        start()
      4 ->
        delete_todo()
        start()

      5 ->
        IO.puts("Goodbye")
    end
  end

  def show_todos do 
    todos = Repo.all(Todo) 
    IO.puts("ALL TODOS\n")
    IO.puts("----------------------------------------------------------------------------------------")

    Enum.each(todos, fn(todo) ->
      IO.puts("#{todo.id}. #{todo.title} by #{todo.user} - on hold: #{todo.on_hold} - completed: #{todo.completed} ")  
      end
    )
    IO.puts("----------------------------------------------------------------------------------------")
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

  def mark_todo_as_complete  do
    show_todos() 
    id = IO.gets("Enter todo id to be marked as completed: \n") |> String.trim_trailing() |> String.to_integer
    todo = Repo.get(Todo, id) 
    changeset = Todo.changeset(todo, %{completed: true})

    case Repo.update(changeset) do
      {:ok, todo} ->
        IO.puts("#{todo.title} by #{todo.user} completed successfuly.")
        show_todos()

      {:error, _} ->
        IO.puts("We are sorry. Some error occurred")
        show_todos()
    end
  end

  def delete_todo  do
    show_todos() 
    id = IO.gets("Enter todo id to be deleted: \n") |> String.trim_trailing() |> String.to_integer
    todo = Repo.get(Todo, id) 

    confirm = IO.gets("Are you sure you want to delete #{todo.title}?(yes) or (no)") |> String.trim_trailing
    
    if confirm == "yes" do 
      case Repo.delete(todo) do
        {:ok, _} ->
          IO.puts("#{todo.title} by #{todo.user} deleted successfuly.")
          show_todos()

        {:error, _} ->
          IO.puts("We are sorry. Some error occurred")
          show_todos()
      end
    end
  end

  def add_remark_for_todo() do 
    show_todos() 
    id = IO.gets("Enter todo id for adding remark.") 
      |> String.trim_leading 
      |> String.to_integer    

    todo = Repo.get(Todo, id)

    IO.puts("Entering remarks for todo #{todo.title}")
    body = IO.gets("Type in your remarks please.") |> String.trim_leading

    remark = %Remark{body: body, todo_id: id}

    case Repo.insert(remark) do 
      {:ok, remark} -> 
        IO.puts("Remark added successfully.")
      {:error, _} ->
        IO.puts("Try again. Some error happened during processing!")

    end
  end

end
