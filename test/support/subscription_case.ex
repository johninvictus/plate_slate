defmodule PlateSlateWeb.SubscriptionCase do
  @moduledoc """
  This module defines the test case to be used by subscription tests
  """

  use ExUnit.CaseTemplate

  using do
    quote do
          use PlateSlateWeb.ChannelCase

          use Absinthe.Phoenix.SubscriptionTest,
            schema: PlateSlateWeb.Schema

          setup do
            PlateSlate.Seeds.run()

            {:ok, socket} = Phoenix.ChannelTest.connect(PlateSlateWeb.UserSocket, %{})

            {:ok, socket} = Absinthe.Phoenix.SubscriptionTest.join_absinthe(socket)

            {:ok, socket: socket}
          end

          import unquote(__MODULE__), only: [menu_item: 1]
    end
  end

  # # handy function for grabbing a fixture
  def menu_item(name) do
    PlateSlate.Repo.get_by!(PlateSlate.Menu.Item, name: name)
  end
end
