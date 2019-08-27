defmodule PlateSlateWeb.Schema do
  use Absinthe.Schema

  alias PlateSlateWeb.Resolvers
  alias PlateSlateWeb.Schema.Middleware

  import_types(PlateSlateWeb.Schema.MenuTypes)
  import_types(PlateSlateWeb.Schema.OrderingTypes)
  import_types(PlateSlateWeb.Schema.CustomTypes)
  import_types(PlateSlateWeb.Schema.AccountsTypes)

  def middleware(middleware, field, %{identifier: :allergy_info} = object) do
    new_middleware = {Absinthe.Middleware.MapGet, to_string(field.identifier)}

    middleware
    |> Absinthe.Schema.replace_default(new_middleware, field, object)
  end

  def middleware(middleware, _field, %{identifier: :mutation}) do
    middleware ++ [Middleware.ChangesetErrors]
  end

  def middleware(middleware, _field, _object) do
    middleware
  end

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

    field :ready_order, :order_result do
      arg(:id, non_null(:id))
      resolve(&Resolvers.Ordering.ready_order/3)
    end

    field :complete_order, :order_result do
      arg(:id, non_null(:id))
      resolve(&Resolvers.Ordering.complete_order/3)
    end

    field :login, :session do
      arg :email, non_null(:string)
      arg :password, non_null(:string)
      arg :role, non_null(:role)

      resolve &Resolvers.Accounts.login/3
    end
  end

  subscription do
    field :new_order, :order do
      config(fn _arg, _info ->
        {:ok, topic: "*"}
      end)

      trigger(:place_order,
        topic: fn
          %{order: _order} -> ["*"]
          _ -> []
        end
      )

      resolve(fn %{order: order}, _, _ ->
        {:ok, order}
      end)
    end

    field :update_order, :order do
      arg(:id, non_null(:id))

      config(fn args, _info ->
        {:ok, topic: args.id}
      end)

      trigger([:ready_order, :complete_order],
        topic: fn
          %{order: order} -> [order.id]
          _ -> []
        end
      )

      resolve(fn %{order: order}, _, _ ->
        {:ok, order}
      end)
    end
  end
end
