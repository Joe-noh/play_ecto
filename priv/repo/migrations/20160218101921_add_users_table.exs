defmodule PlayEcto.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name,          :string
      add :password_hash, :string

      timestamps
    end

    create index(:users, [:name])
  end
end
