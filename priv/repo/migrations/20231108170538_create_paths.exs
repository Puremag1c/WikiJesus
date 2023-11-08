defmodule Wikijesus.Repo.Migrations.CreatePaths do
  use Ecto.Migration

  def change do
    create table(:paths) do
      add :link, :string
      add :path, {:array, :string}

      timestamps()
    end
  end
end
