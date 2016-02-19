defmodule PlayEcto.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias PlayEcto.Post

  schema("users") do
    field :name,          :string
    field :password,      :string, virtual: true
    field :password_hash, :string

    has_many :posts, Post

    timestamps
  end

  @allowed ~w[name password]

  def changeset(model, params) do
    model
    |> cast(params, @allowed)
    |> hash_password
    |> validate_required(:name)
    |> validate_required(:password_hash)
  end

  defp hash_password(changeset) do
    case get_change(changeset, :password) do
      nil      -> changeset
      password -> put_change(changeset, :password_hash, hashing(password))
    end
  end

  defp hashing(_password), do: "hogehogefugafuga"

  def new_post(user, title, body) do
    Ecto.build_assoc(user, :posts)
    |> Post.changeset(%{title: title, body: body})
  end
end
