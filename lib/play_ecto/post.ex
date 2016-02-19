defmodule PlayEcto.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias PlayEcto.User

  schema "posts" do
    field :title, :string
    field :body,  :string

    belongs_to :user, User

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
