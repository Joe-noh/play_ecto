defmodule PlayEctoTest do
  use ExUnit.Case
  import Ecto
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias PlayEcto.{User, Post, Profile, Tag, Repo}

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

    post_params = %{
      title: "今日の日記",
      body: "とても色々なことがありました。"
    }

    {:ok, params: params, post_params: post_params}
  end

  test "insert a user", %{params: params = %{name: name}} do
    User.changeset(%User{}, params) |> Repo.insert!

    user = Repo.get_by!(User, name: name)

    assert user.name == name
    assert user.password      |> is_nil
    assert user.password_hash |> is_binary
  end

  test "insert some users at once" do
    hash = "password_hash_hogehoge"
    now = Ecto.DateTime.from_erl(:calendar.local_time)

    users = [
      %{name: "John", password_hash: hash, inserted_at: now, updated_at: now},
      %{name: "Mary", password_hash: hash, inserted_at: now, updated_at: now},
      %{name: "Alex", password_hash: hash, inserted_at: now, updated_at: now}
    ]

    Repo.insert_all(User, users)

    assert from(u in User, select: count(u.id)) |> Repo.all |> List.first == 3
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

  test "post has many tags", %{params: user_params} do
    user = %User{} |> User.changeset(user_params) |> Repo.insert!

    post1 = build_assoc(user, :posts)
      |> Post.changeset(%{title: "PhoenixとEctoでAPIサーバ", body: "Phoenixはいいぞ"})
      |> Repo.insert!
    post2 = build_assoc(user, :posts)
      |> Post.changeset(%{title: "Ectoを試してみる", body: "Ectoはいいぞ"})
      |> Repo.insert!

    tag1 = %Tag{} |> Tag.changeset(%{name: "Phoenix"}) |> Repo.insert!
    tag2 = %Tag{} |> Tag.changeset(%{name: "Ecto"})    |> Repo.insert!

    post1 |> Repo.preload(:tags) |> Post.changeset(%{}) |> put_assoc(:tags, [tag1, tag2]) |> Repo.update!
    post2 |> Repo.preload(:tags) |> Post.changeset(%{}) |> put_assoc(:tags, [tag2])       |> Repo.update!

    post1_tags = assoc(post1, :tags) |> Repo.all
    post2_tags = assoc(post2, :tags) |> Repo.all

    assert post1_tags |> Enum.map(& &1.name) |> Enum.sort == ["Ecto", "Phoenix"]
    assert post2_tags |> Enum.map(& &1.name) |> Enum.sort == ["Ecto"]

    # 深い関連をpreload
    user = Repo.first!(from u in User, where: u.name == ^user_params.name, preload: [posts: :tags])

    [post | _] = user.posts
    [tag  | _]  = post.tags

    assert %Tag{} = tag
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
