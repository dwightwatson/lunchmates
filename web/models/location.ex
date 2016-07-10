defmodule Lunchmates.Location do
  use Lunchmates.Web, :model

  schema "locations" do
    belongs_to :user, Lunchmates.User
    field :name, :string
    field :description, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :name, :description])
    |> validate_required(:name)
    |> validate_length(:name, min: 3)
  end

  def alphabetical(query) do
    from l in query, order_by: l.name
  end
end
