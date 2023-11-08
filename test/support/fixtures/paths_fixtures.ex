defmodule Wikijesus.PathsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Wikijesus.Paths` context.
  """

  @doc """
  Generate a path.
  """
  def path_fixture(attrs \\ %{}) do
    {:ok, path} =
      attrs
      |> Enum.into(%{
        path: ["URL1", "URL2", "https://en.wikipedia.org/wiki/Jesus"],
        link: "SomeURL"

      })
      |> Wikijesus.Paths.create_path()

    path
  end

end
