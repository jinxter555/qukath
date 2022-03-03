defmodule Qukath.Roles.Role do
  use Ecto.Schema
  import Ecto.Changeset

  alias Qukath.Entities.Entity 
  alias Qukath.Organizations.Orgstruct

  schema "roles" do
    field :name, :string
    belongs_to :orgstruct, Orgstruct
    belongs_to :entity, Entity

    timestamps()
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :orgstruct_id])
    |> validate_required([:name, :orgstruct_id])
    |> cast_assoc(:entity)
    |> cast_assoc(:orgstruct)
  end
end
