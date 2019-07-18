defmodule PlateSlateWeb.Schema do
  use Absinthe.Schema

  alias PlateSlate.{Menu, Repo}
  alias PlateSlateWeb.Resolvers

  query do
    @desc "The list of available items on the menu"
    field :menu_items, list_of(:menu_item) do
      arg(:matching, :string)
      resolve(&Resolvers.Menu.menu_items/3)
    end
  end

  object :menu_item do
    field :id, :id
    field :name, :string
    field :description, :string
  end
end
