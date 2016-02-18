ExUnit.start()

Mix.Task.run "ecto.create", ~w(-r PlayEcto.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r PlayEcto.Repo --quiet)
