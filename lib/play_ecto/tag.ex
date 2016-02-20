defmodule PlayEcto.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  alias PlayEcto.Post

  schema "tags" do
    field :name, :string

    many_to_many :posts, Post, join_through: "posts_tags"

    timestamps
  end

  @allowed ~w[name]

  def changeset(model, params) do
    model
    |> cast(params, @allowed)
    |> validate_required(:name)
  end
end
