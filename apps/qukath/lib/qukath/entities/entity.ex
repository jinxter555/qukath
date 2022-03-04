defmodule Qukath.Entities.Entity do
  use Ecto.Schema
  import Ecto.Changeset

  alias Qukath.Entities.EntityMember
  alias Qukath.Entities.Entity

  schema "entities" do
    # field :parent_id, :integer, null: true
    belongs_to :parent, Entity
    field :type,  Ecto.Enum, values: [employee: 100, org: 101, todo: 102, role: 103, employee_role: 104]
    has_many :members, EntityMember

    timestamps()
  end

  @doc false
  def changeset(entity, attrs) do
    entity
    |> cast(attrs, [:type, :parent_id])
    |> validate_required([:type])
#    |> no_assoc_constraint(:parent_id, message: "You can't delete parent with children.")
  end
end
