defmodule PlateSlate.MenuTest do
  use PlateSlate.DataCase

  alias PlateSlate.Menu

  describe "items" do
    alias PlateSlate.Menu.Item

    @valid_attrs %{added_on: ~D[2010-04-17], description: "some description", name: "some name", price: "120.5"}
    @update_attrs %{added_on: ~D[2011-05-18], description: "some updated description", name: "some updated name", price: "456.7"}
    @invalid_attrs %{added_on: nil, description: nil, name: nil, price: nil}

    def item_fixture(attrs \\ %{}) do
      {:ok, item} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Menu.create_item()

      item
    end

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert Menu.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Menu.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      assert {:ok, %Item{} = item} = Menu.create_item(@valid_attrs)
      assert item.added_on == ~D[2010-04-17]
      assert item.description == "some description"
      assert item.name == "some name"
      assert item.price == Decimal.new("120.5")
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Menu.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      assert {:ok, %Item{} = item} = Menu.update_item(item, @update_attrs)
      assert item.added_on == ~D[2011-05-18]
      assert item.description == "some updated description"
      assert item.name == "some updated name"
      assert item.price == Decimal.new("456.7")
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Menu.update_item(item, @invalid_attrs)
      assert item == Menu.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Menu.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Menu.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Menu.change_item(item)
    end
  end

  describe "categories" do
    alias PlateSlate.Menu.Category

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil}

    def category_fixture(attrs \\ %{}) do
      {:ok, category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Menu.create_category()

      category
    end

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Menu.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Menu.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      assert {:ok, %Category{} = category} = Menu.create_category(@valid_attrs)
      assert category.description == "some description"
      assert category.name == "some name"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Menu.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      assert {:ok, %Category{} = category} = Menu.update_category(category, @update_attrs)
      assert category.description == "some updated description"
      assert category.name == "some updated name"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Menu.update_category(category, @invalid_attrs)
      assert category == Menu.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Menu.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Menu.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Menu.change_category(category)
    end
  end

  describe "item_tags" do
    alias PlateSlate.Menu.ItemTag

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil}

    def item_tag_fixture(attrs \\ %{}) do
      {:ok, item_tag} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Menu.create_item_tag()

      item_tag
    end

    test "list_item_tags/0 returns all item_tags" do
      item_tag = item_tag_fixture()
      assert Menu.list_item_tags() == [item_tag]
    end

    test "get_item_tag!/1 returns the item_tag with given id" do
      item_tag = item_tag_fixture()
      assert Menu.get_item_tag!(item_tag.id) == item_tag
    end

    test "create_item_tag/1 with valid data creates a item_tag" do
      assert {:ok, %ItemTag{} = item_tag} = Menu.create_item_tag(@valid_attrs)
      assert item_tag.description == "some description"
      assert item_tag.name == "some name"
    end

    test "create_item_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Menu.create_item_tag(@invalid_attrs)
    end

    test "update_item_tag/2 with valid data updates the item_tag" do
      item_tag = item_tag_fixture()
      assert {:ok, %ItemTag{} = item_tag} = Menu.update_item_tag(item_tag, @update_attrs)
      assert item_tag.description == "some updated description"
      assert item_tag.name == "some updated name"
    end

    test "update_item_tag/2 with invalid data returns error changeset" do
      item_tag = item_tag_fixture()
      assert {:error, %Ecto.Changeset{}} = Menu.update_item_tag(item_tag, @invalid_attrs)
      assert item_tag == Menu.get_item_tag!(item_tag.id)
    end

    test "delete_item_tag/1 deletes the item_tag" do
      item_tag = item_tag_fixture()
      assert {:ok, %ItemTag{}} = Menu.delete_item_tag(item_tag)
      assert_raise Ecto.NoResultsError, fn -> Menu.get_item_tag!(item_tag.id) end
    end

    test "change_item_tag/1 returns a item_tag changeset" do
      item_tag = item_tag_fixture()
      assert %Ecto.Changeset{} = Menu.change_item_tag(item_tag)
    end
  end
end
