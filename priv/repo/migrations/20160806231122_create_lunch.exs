defmodule Lunchmates.Repo.Migrations.CreateLunch do
  use Ecto.Migration

  def change do
    create table(:lunches) do
      add :date, :date

      timestamps()
    end

    create index(:lunches, [:date])
  end
end
