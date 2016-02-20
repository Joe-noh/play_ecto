defmodule PlayEctoTest do
  use ExUnit.Case
  import Ecto
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias PlayEcto.{User, Post, Profile, Repo}

  setup do
    Ecto.Adapters.SQL.Sandbox.checkout(Repo)

    params = %{
      name: "タナカ",
      password: "password",
      profile: %{
        self_introduction: "こういう者です。",
        github_url: "https://github.com/Joe-noh"
      }
    }

    {:ok, params: params}
  end

  test "insert a user", %{params: params = %{name: name}} do
    User.changeset(%User{}, params) |> Repo.insert!

    user = Repo.get_by!(User, name: name)

    assert user.name == name
    assert user.password      |> is_nil
    assert user.password_hash |> is_binary
  end

  test "user has many posts", %{params: params} do
    user = %User{} |> User.changeset(params) |> Repo.insert!

    build_assoc(user, :posts)
    |> Post.changeset(%{title: "今日の日記", body: "とても色々なことがありました。"})
    |> Repo.insert!

    build_assoc(user, :posts)
    |> Post.changeset(%{title: "昨日の日記", body: "晴れました。"})
    |> Repo.insert!

    posts = assoc(user, :posts) |> Repo.all

    assert length(posts) == 2
  end

  test "user has a profile", %{params: params = %{name: name}} do
    %User{} |> User.changeset(params) |> Repo.insert!  # Profileも一緒にinsert

    user = from(u in User, where: u.name == ^name, preload: :profile) |> Repo.first!

    assert user.profile.self_introduction == get_in(params, [:profile, :self_introduction])
    assert user.profile.github_url        == get_in(params, [:profile, :github_url])

    Profile.changeset(user.profile, %{self_introduction: "こんちわ"}) |> Repo.update!

    user = from(u in User, where: u.name == ^name, preload: :profile) |> Repo.first!

    assert user.profile.self_introduction == "こんちわ"
  end

  @allowed ~w[name password]

  test "cast_assoc/3 with required: true", %{params: params} do
    params = Map.drop(params, [:profile])
    changeset = %User{}
      |> cast(params, @allowed)
      |> cast_assoc(:profile, required: true)

    assert changeset.errors == [profile: "can't be blank"]
  end
end
