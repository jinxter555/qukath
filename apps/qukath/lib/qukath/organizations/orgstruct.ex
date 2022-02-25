defmodule Qukath.Organizations.Orgstruct do
  use Ecto.Schema
  import Ecto.Changeset

  alias Qukath.Organizations.Employee
  alias Qukath.Entities.Entity

  schema "orgstructs" do
    field :name, :string
    field :type, Ecto.Enum, values: [corporate_group: 100, company: 101, department: 102, team: 103, league: 104, external: 200]

    #field :leader_entity_id, :id
    #field :entity_id, :id
    belongs_to :leader_entity, Entity
    belongs_to :entity, Entity
    has_many :employees, Employee

    timestamps()
  end

  @doc false
  def changeset(orgstruct, attrs) do
    orgstruct
    |> cast(attrs, [:name, :type, :entity_id, :leader_entity_id])
    |> cast_assoc(:entity)
    |> cast_assoc(:leader_entity)
    |> validate_required([:name, :type, :entity_id, :leader_entity_id])
  end
end
