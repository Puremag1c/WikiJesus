defmodule Wikijesus.Paths.Path do
  use Ecto.Schema
  import Ecto.Changeset

  schema "paths" do
    field :link, :string
    field :path, {:array, :string}

    timestamps()
  end

  @doc false
  def changeset(path, attrs) do
    path
    |> cast(attrs, [:link, :path])
    |> validate_required([:link, :path])
  end
end
