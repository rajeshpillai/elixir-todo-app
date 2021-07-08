import Config

config :elixir_todo_app, ecto_repos: [ElixirTodoApp.Repo]

config :elixir_todo_app, ElixirTodoApp.Repo,
  database: "elixir_todo_app_repo",
  username: "postgres",
  password: "root123",
  hostname: "localhost"
