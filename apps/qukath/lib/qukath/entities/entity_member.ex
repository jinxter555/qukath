defmodule Qukath.Entities.EntityMember do
  use Ecto.Schema
  import Ecto.Changeset

  alias Qukath.Entities.Entity

  schema "entity_members" do
    # field :entity_id, :integer
    belongs_to :entity, Entity
    #field :member_id, :integer
    belongs_to :member, Entity

    timestamps()
  end

  @doc false
  def changeset(entity_member, attrs) do
    entity_member
    |> cast(attrs, [:entity_id, :member_id])
    |> validate_required([:entity_id, :member_id])
  end
end
