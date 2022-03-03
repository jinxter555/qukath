defmodule Qukath.Roles.EmployeeRole do
  use Ecto.Schema
  import Ecto.Changeset

  schema "employee_roles" do

    field :entity_id, :id
    field :orgstruct_id, :id
    field :employee_id, :id
    field :role_id, :id

    timestamps()
  end

  @doc false
  def changeset(employee_role, attrs) do
    employee_role
    |> cast(attrs, [])
    |> validate_required([])
  end
end
