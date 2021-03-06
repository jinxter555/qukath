defmodule Qukath.Roles.EmployeeRole do
  use Ecto.Schema
  import Ecto.Changeset

  alias Qukath.Entities.Entity 
  alias Qukath.Organizations.Orgstruct
  alias Qukath.Roles.Role
  alias Qukath.Organizations.{Employee}


  schema "employee_roles" do
    belongs_to :entity, Entity
    belongs_to :orgstruct, Orgstruct
    belongs_to :employee, Employee
    belongs_to :role, Role

    timestamps()
  end

  @doc false
  def changeset(employee_role, attrs) do
    employee_role
    |> cast(attrs, [:employee_id, :role_id, :orgstruct_id])
    |> validate_required([:employee_id, :role_id, :orgstruct_id])
    |> cast_assoc(:entity)
    |> cast_assoc(:role)
    |> cast_assoc(:employee)
    |> cast_assoc(:orgstruct)

  end
end
