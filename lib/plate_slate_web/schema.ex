defmodule PlateSlateWeb.Schema do
  use Absinthe.Schema

  alias PlateSlateWeb.Resolvers

  import_types(PlateSlateWeb.Schema.MenuTypes)
  import_types(PlateSlateWeb.Schema.OrderingTypes)
  import_types(PlateSlateWeb.Schema.CustomTypes)

  query do
    field :menu_items, list_of(:menu_item) do
      arg(:filter, :menu_item_filter)
      arg(:order, type: :sort_order, default_value: :asc)
      resolve(&Resolvers.Menu.menu_items/3)
    end

    field :search, list_of(:search_result) do
      arg(:matching, non_null(:string))

      resolve(&Resolvers.Menu.search/3)
    end
  end

  mutation do
    field :create_menu_item, :menu_item_result do
      arg(:input, non_null(:menu_item_input))
      resolve(&Resolvers.Menu.create_item/3)
    end

    field :place_order, :order_result do
      arg(:input, non_null(:place_order_input))
      resolve(&Resolvers.Ordering.place_order/3)
    end
  end

  subscription do
    field :new_order, :order do

      config fn _arg, _info ->
        {:ok, topic: "*"}
      end
    end
  end

  enum :sort_order do
    value(:asc)
    value(:desc)
  end
end
