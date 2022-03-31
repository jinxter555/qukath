defmodule Qukath.Skillsets.Skillset do
  use Ecto.Schema
  import Ecto.Changeset

  schema "skillsets" do
    field :name, :string
    field :role_id, :id

    timestamps()
  end

  @doc false
  def changeset(skillset, attrs) do
    skillset
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
