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

















