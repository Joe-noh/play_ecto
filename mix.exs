defmodule PlayEcto.Mixfile do
  use Mix.Project

  def project do
    [app: :play_ecto,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger, :ecto, :postgrex]]
  end

  defp deps do
    [
      {:ecto, "~> 0.11"},
      {:postgrex, "~> 0.8"}
    ]
  end
end
