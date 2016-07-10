defmodule Lunchmates.Repo.Migrations.CreateLocation do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add :user_id, references(:users, on_delete: :nilify_all)
      add :name, :string
      add :description, :text

      timestamps()
    end

    create index(:locations, [:user_id])
  end
end
