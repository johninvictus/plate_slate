defmodule PlateSlateWeb.Schema do
  use Absinthe.Schema

  alias PlateSlateWeb.Resolvers

  import_types(PlateSlateWeb.Schema.MenuTypes)
  import_types(PlateSlateWeb.Schema.CustomTypes)

  query do
    field :menu_items, list_of(:menu_item) do
      arg(:filter, :menu_item_filter)
      arg(:order, type: :sort_order, default_value: :asc)
      resolve(&Resolvers.Menu.menu_items/3)
    end

    field :search, list_of(:search_result) do
      arg :matching, non_null(:string)

      resolve &Resolvers.Menu.search/3
    end
  end

  enum :sort_order do
    value(:asc)
    value(:desc)
  end
end
