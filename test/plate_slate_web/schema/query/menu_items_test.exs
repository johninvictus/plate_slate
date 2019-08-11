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

    assert %{"data" => items} = json_response(conn, 200)
  end

  @query """
  {
    menuItems(filter: {name: "reu"}){
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
    menuItems(filter: {name: 123}){
      name
    }
  }
  """
  test "menuItems field returns errors when using a bad value" do
    response = get build_conn(), "/api", query: @query

    assert %{
             "errors" => [%{"message" => message}]
           } = json_response(response, 200)

    assert message ==
             "Argument \"filter\" has invalid value {name: 123}.\nIn field \"name\": Expected type \"String\", found 123."
  end

  @query """
    {
      menuItems(filter: {category: "Sandwiches", tag: "Vegetarian"}){
        name
      }
    }
  """
  test "menuItems field returns menuItems, filtering with a literal" do
    response = get(build_conn(), "/api", query: @query)

    assert %{
             "data" => %{"menuItems" => [%{"name" => "Vada Pav"}]}
           } == json_response(response, 200)
  end

  @query """
  query($filter: MenuItemFilter!){
    menuItems(filter: $filter){
      name
      addedOn
    }
  }
  """
  @variables %{filter: %{"addedBefore" => "2017-01-20"}}
  test "menuItems filtered by custom scalar" do
    sides = PlateSlate.Repo.get_by!(PlateSlate.Menu.Category, name: "Sides")

    %PlateSlate.Menu.Item{
      name: "Garlic Fries",
      added_on: ~D[2017-01-01],
      price: 2.50,
      category: sides
    }
    |> PlateSlate.Repo.insert!()

    response = get(build_conn(), "/api", query: @query, variables: @variables)

    assert %{
             "data" => %{
               "menuItems" => [%{"name" => "Garlic Fries", "addedOn" => "2017-01-01"}]
             }
           } == json_response(response, 200)
  end

  @query """
  query Search($term: String!) {
  search(matching: $term) {
  ... on MenuItem { name }
  ... on Category { name }
  __typename
  }
  }
  """
  @variables %{term: "e"}
  test "search returns a list of menu items and categories" do
    response = get(build_conn(), "/api", query: @query, variables: @variables)
    assert %{"data" => %{"search" => results}} = json_response(response, 200)
    assert length(results) > 0
    assert Enum.find(results, &(&1["__typename"] == "Category"))
    assert Enum.find(results, &(&1["__typename"] == "MenuItem"))
  end
end
