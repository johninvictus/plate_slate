defmodule PlateSlate.Repo.Migrations.CreateItemTags do
  use Ecto.Migration

  def change do
    create table(:item_tags) do
      add :description, :string
      add :name, :string

      timestamps()
    end

  end
end
