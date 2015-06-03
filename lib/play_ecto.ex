defmodule PlayEcto do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(PlayEcto.Repo, [])
    ]

    opts = [strategy: :one_for_one, name: PlayEcto.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
