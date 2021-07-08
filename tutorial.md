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



















