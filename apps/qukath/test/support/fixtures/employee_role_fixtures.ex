defmodule Qukath.EmployeeRoleFixtures do

  #alias Qukath.EmployeeRoles
  import Qukath.Factory

  @doc """
  Generate a employee_role.
  """

  def employee_role_fixture(attrs \\ %{}) do
    orgstruct = insert(:orgstruct)
    employee = insert(:employee)
    role  = insert(:role, %{orgstruct: orgstruct})

    {:ok, employee_role} = 
      Enum.into(attrs, %{
        orgstruct_id:  orgstruct.id,
        role_id:  role.id,
        employee_id: employee.id }) |> Qukath.EmployeeRoles.create_employee_role()
    employee_role
  end

end

