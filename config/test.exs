use Mix.Config

config :play_ecto, PlayEcto.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "play_ecto_repo_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
