defmodule Lunchmates.LunchTest do
  use Lunchmates.ModelCase

  alias Lunchmates.Lunch

  @valid_attrs %{date: %{day: 17, month: 4, year: 2010}}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Lunch.changeset(%Lunch{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Lunch.changeset(%Lunch{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "upcoming/1 orders by date" do
    third = Repo.insert!(Lunch.changeset(%Lunch{}, %{date: %{day: 1, month: 1, year: 2000}}))
    second = Repo.insert!(Lunch.changeset(%Lunch{}, %{date: %{day: 2, month: 1, year: 2000}}))
    first =Repo.insert!(Lunch.changeset(%Lunch{}, %{date: %{day: 3, month: 1, year: 2000}}))

    results = Lunch
    |> Lunch.upcoming()
    |> select([l], l.date)
    |> Repo.all

    assert results == Enum.map([first, second, third], fn (d) -> d.date end)
  end
end
