defmodule PlateSlate.Ordering do
  @moduledoc """
  The Ordering context.
  """

  import Ecto.Query, warn: false
  alias PlateSlate.Repo

  alias PlateSlate.Ordering.Order

  def create_order(attrs \\ Map.new()) do
    attrs = Map.update(attrs, :items, [], &build_item/1)

    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  defp build_item(items) do
    for item <- items do
      menu_item = PlateSlate.Menu.get_item!(item.menu_item_id)
      %{name: menu_item.name, quantity: item.quantity, price: menu_item.price}
    end
  end
end
