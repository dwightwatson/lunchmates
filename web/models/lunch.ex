defmodule Lunchmates.Lunch do
  use Lunchmates.Web, :model

  schema "lunches" do
    field :date, Ecto.Date

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:date])
    |> validate_required([:date])
  end

  def upcoming(query) do
    from l in query, order_by: [desc: l.date]
  end
end
