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








