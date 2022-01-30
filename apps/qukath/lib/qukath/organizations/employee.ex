defmodule Qukath.Organizations.Employee do
  use Ecto.Schema
  import Ecto.Changeset

  alias Qukath.Accounts.User 
  alias Qukath.Entities.Entity 
  alias Qukath.Organizations.Orgstruct

  schema "employees" do
    field :name, :string
    belongs_to :orgstruct, Orgstruct
    belongs_to :user, User
    belongs_to :entity, Entity

    timestamps()
  end

  @doc false
  def changeset(employee, attrs) do
    employee
    |> cast(attrs, [:name, :user_id, :entity_id, :orgstruct_id])
    |> cast_assoc(:user)
    |> cast_assoc(:entity)
    |> cast_assoc(:orgstruct)
    |> validate_required([:name, :orgstruct_id])
  end
end
