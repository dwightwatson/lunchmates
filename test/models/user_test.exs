defmodule Lunchmates.UserTest do
  use Lunchmates.ModelCase

  alias Lunchmates.User

  @valid_attrs %{name: "John Doe", email: "john@example.com", password: "secret"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "create_changeset password must be longer than 6 characters" do
    attrs = Map.put(@valid_attrs, :password, "12345")
    changeset = User.create_changeset(%User{}, attrs)
    assert changeset.errors[:password]
  end

  test "create_changeset password must be shorter than 100 characters" do
    attrs = Map.put(@valid_attrs, :password, String.duplicate("1", 101))
    changeset = User.create_changeset(%User{}, attrs)
    assert changeset.errors[:password]
  end

  test "create_changeset with valid attributes hashes password" do
    changeset = User.create_changeset(%User{}, @valid_attrs)
    %{password: password, password_hash: password_hash} = changeset.changes
    assert changeset.valid?
    assert password_hash
    assert Comeonin.Bcrypt.checkpw(password, password_hash)
  end
end
