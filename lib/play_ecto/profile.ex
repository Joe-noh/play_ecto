defmodule PlayEcto.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  alias PlayEcto.User

  schema "profiles" do
    field :self_introduction, :string
    field :github_url, :string

    belongs_to :user, User

    timestamps
  end

  @allowed ~w[self_introduction github_url]

  def changeset(model, params) do
    model
    |> cast(params, @allowed)
  end
end
