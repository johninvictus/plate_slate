defmodule PlateSlateWeb.Schema.Query.MenuItemsTest do
  use PlateSlateWeb.ConnCase

  setup do
    PlateSlate.Seeds.run()
  end

  @query """
  {
    menuItems {
      name
    }
  }
  """
  test "menuItems field returns menu items" do
    conn = build_conn()
    conn = get conn, "/api", query: @query

    assert = %{"data" => items} = json_response(conn, 200)
  end

  @query """
  {
    menuItems(matching: "reu"){
      name
    }
  }
  """
  test "menuItems field returns menu items filtered by name" do
    response = get build_conn(), "/api", query: @query

    assert json_response(response, 200) == %{
             "data" => %{
               "menuItems" => [
                 %{"name" => "Reuben"}
               ]
             }
           }
  end

  @query """
  {
    menuItems(matching: 123){
      name
    }
  }
  """
  test "menuItems field returns errors when using a bad value" do
    response = get build_conn(), "/api", query: @query

    assert %{
             "errors" => [%{"message" => message}]
           } = json_response(response, 200)

    assert message == "Argument \"matching\" has invalid value 123."
  end
end
