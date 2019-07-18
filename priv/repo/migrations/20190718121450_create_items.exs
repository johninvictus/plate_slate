defmodule PlateSlate.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :description, :string
      add :name, :string, null: false
      add :price, :decimal, null: false
      add :added_on, :date, null: false, default: fragment("NOW()")

      add :category_id, references(:categories, on_delete: :nothing)


      timestamps()
    end
  end
end
