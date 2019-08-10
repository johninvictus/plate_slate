defmodule PlateSlate.Menu do
  @moduledoc """
  The Menu context.
  """
  import Ecto.Query, warn: false
  alias PlateSlate.Repo

  alias PlateSlate.Menu.{Category, Item}

  def list_items do
    Repo.all(Item)
  end

  def list_items(filters) do
    filters
    |> Enum.reduce(Item, fn
      {_, nil}, query ->
        query

      {:order, order}, query ->
        from q in query, order_by: {^order, :name}

      {:filter, filter}, query ->
        query |> filter_with(filter)
    end)
    |> Repo.all()
  end

  def filter_with(query, filter) do
    Enum.reduce(filter, query, fn
      {:name, name}, query ->
        from q in query, where: ilike(q.name, ^"%#{name}%")

      {:priced_above, price}, query ->
        from q in query, where: q.price >= ^price

      {:priced_below, price}, query ->
        from q in query, where: q.price <= ^price

      {:added_after, date}, query ->
        from q in query, where: q.added_on >= ^date

      {:added_before, date}, query ->
        from q in query, where: q.added_on <= ^date

      {:category, category_name}, query ->
        from q in query,
          join: c in assoc(q, :category),
          where: ilike(c.name, ^"%#{category_name}%")

      {:tag, tag_name}, query ->
        from q in query,
          join: t in assoc(q, :tags),
          where: ilike(t.name, ^"%#{tag_name}%")
    end)
  end

  @search [Item, Category]
  def search(term) do
    pattern = "%#{term}%"
    Enum.flat_map(@search, &search_ecto(&1, pattern))
  end

  def create_item(attrs \\ Map.new()) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert
  end

  defp search_ecto(ecto_schema, pattern) do
    Repo.all(
      from q in ecto_schema,
        where: ilike(q.name, ^pattern) or ilike(q.description, ^pattern)
    )
  end
end
