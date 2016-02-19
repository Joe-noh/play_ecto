defmodule PlayEctoTest do
  use ExUnit.Case
  import Ecto

  alias PlayEcto.{User, Repo}

  setup do
    Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    :ok
  end

  test "User operation" do
    changeset = User.changeset(%User{}, %{name: "タナカ", password: "tanaka1234"})

    Repo.insert!(changeset)
    user = Repo.get_by(User, name: "タナカ")

    assert user.name == "タナカ"
    assert user.password      |> is_nil
    assert user.password_hash |> is_binary
  end

  test "User has many posts" do
    user = %User{}
      |> User.changeset(%{name: "タナカ", password: "password"})
      |> Repo.insert!

    post = User.new_post(user, "今日の日記", "とても色々なことがありました。")
      |> Repo.insert!

    assert post.title == "今日の日記"
    assert post.body  == "とても色々なことがありました。"

    # userからpostsを取得
    posts = assoc(user, :posts) |> Repo.all
    assert List.first(posts).title == "今日の日記"

    # postのuserを取得
    user = assoc(post, :user) |> Repo.first
    assert user.name == "タナカ"
  end
end
