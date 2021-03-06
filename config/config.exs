use Mix.Config

config :play_ecto, PlayEcto.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "play_ecto_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

import_config "#{Mix.env}.exs"
