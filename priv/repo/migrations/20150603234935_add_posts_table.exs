defmodule PlayEcto.Repo.Migrations.AddPostsTable do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :body,  :text

      add :user_id, :integer

      timestamps
    end
  end
end
