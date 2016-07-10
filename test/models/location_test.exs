defmodule Lunchmates.LocationTest do
  use Lunchmates.ModelCase

  alias Lunchmates.Location

  @valid_attrs %{name: "KFC", description: "Finger lickin' good"}
  @invalid_attrs %{name: nil}

  test "changeset with valid attributes" do
    changeset = Location.changeset(%Location{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Location.changeset(%Location{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "alphabetical/1 orders by name" do
    Repo.insert!(%Location{name: "c"})
    Repo.insert!(%Location{name: "a"})
    Repo.insert!(%Location{name: "b"})

    results = Location
    |> Location.alphabetical()
    |> select([l], l.name)
    |> Repo.all

    assert results == ~w(a b c)
  end
end
