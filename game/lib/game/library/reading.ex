defmodule Game.Library.Reading do
  use Ecto.Schema
  import Ecto.Changeset

  schema "readings" do
    field :name, :string
    field :text, :string
    field :steps, :integer

    timestamps()
  end

  @doc false
  def changeset(reading, attrs) do
    reading
    |> cast(attrs, [:name, :text, :steps])
    |> validate_required([:name, :text, :steps])
  end
end
