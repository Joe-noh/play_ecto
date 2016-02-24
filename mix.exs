defmodule PlayEcto.Mixfile do
  use Mix.Project

  def project do
    [app: :play_ecto,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [
      applications: [:logger, :ecto, :postgrex],
      mod: {PlayEcto, []}
    ]
  end

  defp deps do
    [
      {:ecto, github: "elixir-lang/ecto", ref: "6464da626276073495a8dcb61d37b3baafcde834"},
      {:postgrex, ">= 0.0.0"}
    ]
  end
end
