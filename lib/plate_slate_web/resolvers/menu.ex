defmodule PlateSlateWeb.Resolvers.Menu do
  alias PlateSlate.{Menu, Repo}

  def menu_items(_, args, _) do
    {:ok, Menu.list_items(args)}
  end

  def items_for_category(category, _, _) do
    query = Ecto.assoc(category, :items)

    {:ok, Repo.all(query)}
  end

  def search(_, %{matching: term}, _) do
    {:ok, Menu.search(term)}
  end

  def create_item(_, %{input: params}, _) do
    case Menu.create_item(params) do
      {:error, _} ->
        {:error, "Could not create menu item"}
      {:ok, _} = success ->
        success
    end
  end
end
