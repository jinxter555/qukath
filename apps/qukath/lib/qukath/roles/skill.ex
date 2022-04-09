defmodule Qukath.Roles.Skill do
  use Ecto.Schema
  import Ecto.Changeset

   alias Qukath.Roles.Role
   alias Qukath.Resources.Permit

  schema "skills" do
    belongs_to :role, Role
    belongs_to :permit, Permit

    timestamps()
  end

  @doc false
  def changeset(skill, attrs) do
    skill
    |> cast(attrs, [:role_id, :permit_id])
    |> validate_required([:role_id, :permit_id])
  end
end
