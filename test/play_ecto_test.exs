defmodule PlayEctoTest do
  use ExUnit.Case

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
end
