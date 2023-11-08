defmodule Wikijesus.PathsTest do
  use Wikijesus.DataCase

  alias Wikijesus.Paths

  describe "paths" do
    alias Wikijesus.Paths.Path

    import Wikijesus.PathsFixtures

    @invalid_attrs %{link: 2, path: {1,2}}

    test "list_paths/0 returns all paths" do
      path = path_fixture()
      assert Paths.list_paths() == [path]
    end

    test "get_path!/1 returns the path with given id" do
      path = path_fixture()
      assert Paths.get_path!(path.id) == path
    end

    test "create_path/1 with valid data creates a path" do
      valid_attrs = %{path: ["URL1", "URL2", "https://en.wikipedia.org/wiki/Jesus"], link: "SomeURL"}

      assert {:ok, %Path{} = path} = Paths.create_path(valid_attrs)
    end

    test "create_path/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Paths.create_path(@invalid_attrs)
    end

    test "update_path/2 with valid data updates the path" do
      path = path_fixture()
      update_attrs = %{}

      assert {:ok, %Path{} = path} = Paths.update_path(path, update_attrs)
    end

    test "update_path/2 with invalid data returns error changeset" do
      path = path_fixture()
      assert {:error, %Ecto.Changeset{}} = Paths.update_path(path, @invalid_attrs)
      assert path == Paths.get_path!(path.id)
    end

    test "delete_path/1 deletes the path" do
      path = path_fixture()
      assert {:ok, %Path{}} = Paths.delete_path(path)
      assert_raise Ecto.NoResultsError, fn -> Paths.get_path!(path.id) end
    end

    test "change_path/1 returns a path changeset" do
      path = path_fixture()
      assert %Ecto.Changeset{} = Paths.change_path(path)
    end
  end

end
