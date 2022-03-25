defmodule Qukath.Resources.Resource do
  use Ecto.Schema
  import Ecto.Changeset

  alias Qukath.Entities.Entity 
  alias Qukath.Organizations.Orgstruct

  schema "resources" do
    field :name, :string
    belongs_to :entity, Entity
    # field :owner_id, :id
    belongs_to :owner, Entity
    belongs_to :orgstruct, Orgstruct

    timestamps()
  end

  @doc false
  def changeset(resource, attrs) do
    resource
    |> cast(attrs, [:name, :orgstruct_id])
    |> validate_required([:name, :orgstruct_id])
    |> cast_assoc(:entity)
    |> cast_assoc(:orgstruct)

  end
end
