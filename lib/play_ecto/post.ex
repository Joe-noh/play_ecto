defmodule PlayEcto.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias PlayEcto.{User, Tag}

  schema "posts" do
    field :title, :string
    field :body,  :string

    belongs_to :user, User
    many_to_many :tags, Tag, join_through: "posts_tags"

    timestamps
  end

  @allowed ~w[title body]

  def changeset(model, params) do
    model
    |> cast(params, @allowed)
    |> validate_required(:title)
    |> validate_required(:body)
    |> validate_required(:user_id)
  end
end
