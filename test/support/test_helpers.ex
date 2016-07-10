defmodule Lunchmates.TestHelpers do
  alias Lunchmates.Repo

  def insert_user(attrs \\ %{}) do
    changes = Dict.merge(%{
      name: "John Doe",
      email: "#{Base.encode16(:crypto.rand_bytes(8))}@example.com",
      password: "secret"
    }, attrs)

    %Lunchmates.User{}
    |> Lunchmates.User.create_changeset(changes)
    |> Repo.insert!()
  end

  def insert_location(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:locations, attrs)
    |> Repo.insert!()
  end
end
