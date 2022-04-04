defmodule Qukath.Roles.Skillset do
  use Ecto.Schema
  import Ecto.Changeset

  alias Qukath.Roles.Role


  schema "skillsets" do
    field :name, :string
    belongs_to :role, Role

    timestamps()
  end

  @doc false
  def changeset(skillset, attrs) do
    skillset
    |> cast(attrs, [:name, :role_id])
    |> validate_required([:name, :role_id])
    |> cast_assoc(:role)
  end
end
