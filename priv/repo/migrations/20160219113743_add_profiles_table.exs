defmodule PlayEcto.Repo.Migrations.AddProfilesTable do
  use Ecto.Migration

  def change do
    create table(:profiles) do
      add :self_introduction, :text
      add :github_url,  :string
      add :user_id, references(:users)

      timestamps
    end

    create unique_index(:profiles, [:github_url])
  end
end
