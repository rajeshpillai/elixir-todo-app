# Overview
A system to manage todos.

# Features
- Create Todos
- Edit Todos
- Mark Todo as completed
- Add remarks to todo

# Create a new project
Create a mix project with supervisor

$ mix new elixir_todo_app

# Setup Database
Update mix.exs with following dependencies
 {:ecto_sql, "~> 3.6"},
 {:postgrex, ">=0.0.0"}

# Install Dependencies
Run the below command in your terminal/command prompt to install dependencies 
$ mix deps.get 

# Generate a repository
$ mix ecto.gen.repo -r ElixirTodoApp.Repo

# Configure your repo
In 'config/confix.exs' make the following changes
```
import Config

config :elixir_todo_app, ecto_repos: [ElixirTodoApp.Repo]
      
config :elixir_todo_app, ElixirTodoApp.Repo,
  database: "elixir_todo_app_repo",
  username: "postgres",
  password: "root123",
  hostname: "localhost"
```

# application.ex
In application.ex add the following to the start function
```
children = [
    {ElixirTodoApp.Repo, []}
]

```

# CAUTION:  
Ensure your postgres server is running before running the migration.Ensure you
$ sudo service postgresql start

# Create migration file
$ mix ecto.create
$ mix ecto.gen.migration create_todos

After running the above command a migration file will be created in the folder `priv/repo/migrations' with the name
xxxxxx_create_todos.exs

# Update the migration file
Open the xxxx_create_todos.exs file and update the script as shown below.


```
 def change do
    create table (:todos) do
      add :title, :string
      add :user, :string
      add :completed, :boolean
    end
  end
```

# Run the migration

$ mix ecto.migrate

After the above command is executed a table called "todos" should be created in the database.


# Create a model/schema to work the the database table in your application
Create a file named "todo.ex" in the "lib/elixir_todo_app" folder.  Update the file with the follow
code snippet.

```
defmodule ElixirTodoApp.Todo  do
  use Ecto.Schema

  schema "todos" do
    field :title, :string
    field :user, :string
    field :completed, :boolean
  end
end

```
# Test the application
Open up 'lib/elixir_todo_app.ex' and add the code as shown below.
```
defmodule ElixirTodoApp do
  def start do
    IO.puts ("Hello Elixir...")
  end
end

```

Test the code in the terminal window 

$ iex -S mix
iex > ElixirTodoApp.start

After running the above command, "Hello Elixir..." should be printed on the screen.


# Add new todo feature
Let's capture information form user

```
defmodule ElixirTodoApp do
  alias ElixirTodoApp.Todo
  alias ElixirTodoApp.Repo

  def start do
    IO.puts ("Hello, What  do you want to do?")
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
    title = IO.gets("What do you want to get accomplished?\n") |> String.trim_trailing
    user = IO.gets("Your name plase?\n") |> String.trim_trailing
  end

end
```

## Add new todo function
Modify the add_todo function as shown below

```
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
```
# New Todo Validation
Changeset are built into Ecto which provides validations and other features.

Add the following changeset function in 'lib/elixir_todo_app/todo.ex'

```
def changeset(todo, params \\ %{}) do
  todo 
    |> Ecto.Changeset.cast(params, [:title, :user, :completed])
    |> Ecto.Changeset.validate_required([:title, :user])
end
```

Modify the 'lib/elixir_todo_app.ex' file as shown below.  The main change are we are capturing changeset and passing the changeset into Repo.insert function

```
def add_todo do
    IO.puts("Adding a todo")
    title = IO.gets("What do you want to accomplish today?\n") |> String.trim_trailing
    user = IO.gets("Your name please?\n") |> String.trim_trailing

    # Create a new todo
    todo = %Todo{title: title, user: user, completed: false}
    changeset = Todo.changeset(todo, %{})

    case Repo.insert(changeset) do
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
```

At this point open up iex using iex -S mix and try to create a new todo with empty title and user.  You 
should get an error on your terminal as the validations kicks in and prevents saving invalid items to the
database.

## Add error handling to add_todo
Add the :error clause after the :ok clause

```

  {:error, _} ->
    IO.puts("Please enter valid values")
    add_todo()
```


## Create migration script for creating an on_hold field in the todos table
$ mix ecto.gen.migration add_on_hold_to_todo 

After running the above script a migration file will be created.  Open the file, named 'xxxx_add_on_hold_to_todos.exs" and update the script as shown below.

```
 def change do
  alter table(:todos) do 
    add :on_hold, :boolean
  end
end

```

## Update the Todo Schema with the new field (lib/elixir_todo_app/todo.ex)
I also added default values of boolean fields to false.

```
schema "todos" do
  field :title, :string
  field :user, :string
  field :completed, :boolean, default: :false
  field :on_hold, :boolean, default: :false
end
```

## Run the migration
$ mix ecto.migrate

## Update the elixir_todo_app.ex to capture the on_hold field
Only the changed code is displayed below.  Refer full source code for clarity.

```
on_hold = IO.gets("Do you want to keep this task on hold for future?(yes) or (no)\n") |> String.trim_trailing

todo = %Todo{title: title, user: user, completed: false, on_hold: on_hold == "yes"}
changeset = Todo.changeset(todo, %{})
```

## Refactor the show todos to it's own function

```
  def show_todos do 
    todos = Repo.all(Todo) 
    IO.puts("----------------------------------------")

    Enum.each(todos, fn(todo) ->
      IO.puts("#{todo.title} by #{todo.user} - on hold: #{todo.on_hold}")  
      end
    )
    IO.puts("----------------------------------------")
  end
```

Update the add_todo function to use show_todos 

```
 case Repo.insert(changeset) do
    {:ok, todo} ->
      IO.puts("#{todo.title} by #{todo.user} created successfuly.")
      
      show_todos()

    {:error, _} ->
      IO.puts("Please enter valid values")
      add_todo()
  end
```

# Mark todo as complete
Add an option to capture todo ID as input from user to mark todo as complete.  Modify the show_todos to list ID's as well.
(Refer the code for more details, but try to implement on our own first)






















