defmodule Qukath.EmployeeRoleTest do
  use Qukath.DataCase

  import Qukath.Factory

  alias Qukath.EmployeeRoles

  describe "employee_roles" do
    alias Qukath.Roles.EmployeeRole

    import Qukath.EmployeeRoleFixtures

    @invalid_attrs %{employee_id: nil}

    #@tag :skip
    test "list_employee_roles/0 returns all employee_roles" do
      employee_role = employee_role_fixture() |> forget(:entity)
      #IO.inspect employee_role
      assert EmployeeRoles.list_employee_roles() == [employee_role]
    end

    #@tag :skip
    test "get_employee_role!/1 returns the employee_role with given id" do
      employee_role = employee_role_fixture() |> forget(:entity)
      assert EmployeeRoles.get_employee_role!(employee_role.id) == employee_role
    end

    #@tag :skip
    test "create_employee_role/1 with valid data creates a employee_role" do
      orgstruct = insert(:orgstruct)
      employee = insert(:employee)
      role  = insert(:role, %{orgstruct: orgstruct})

      valid_attrs = %{ 
        orgstruct_id: orgstruct.id,
        employee_id: employee.id,
        role_id: role.id}

      assert {:ok, %EmployeeRole{} = _employee_role} = EmployeeRoles.create_employee_role(valid_attrs)
    end

    #@tag :skip
    test "create_employee_role/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = EmployeeRoles.create_employee_role(@invalid_attrs)
    end

    #@tag :skip
    test "update_employee_role/2 with valid data updates the employee_role" do
      employee_role = employee_role_fixture() |> forget(:entity)
      update_attrs = %{}

      assert {:ok, %EmployeeRole{} = _employee_role} = EmployeeRoles.update_employee_role(employee_role, update_attrs)
    end

    #@tag :skip
    test "update_employee_role/2 with invalid data returns error changeset" do
      employee_role = employee_role_fixture() |> forget(:entity)
      assert {:error, %Ecto.Changeset{}} = EmployeeRoles.update_employee_role(employee_role, @invalid_attrs)
      assert employee_role == EmployeeRoles.get_employee_role!(employee_role.id)
    end

    #@tag :skip
    test "delete_employee_role/1 deletes the employee_role" do
      employee_role = employee_role_fixture() 
      assert {:ok, %EmployeeRole{}} = EmployeeRoles.delete_employee_role(employee_role)
      assert_raise Ecto.NoResultsError, fn -> EmployeeRoles.get_employee_role!(employee_role.id) end
    end

    #@tag :skip
    test "change_employee_role/1 returns a employee_role changeset" do
      employee_role = employee_role_fixture()
      assert %Ecto.Changeset{} = EmployeeRoles.change_employee_role(employee_role)
    end
  end


   def forget(struct, field, cardinality \\ :one) do
    %{struct | 
      field => %Ecto.Association.NotLoaded{
        __field__: field,
        __owner__: struct.__struct__,
        __cardinality__: cardinality
      }
    }
  end

end
