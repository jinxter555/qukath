defmodule Qukath.EmployeexRoleTest do
  use Qukath.DataCase

  alias Qukath.EmployeexRole

  describe "employee_x_roles" do
    alias Qukath.EmployeexRole.EmployeeRole

    import Qukath.EmployeexRoleFixtures

    @invalid_attrs %{}

    test "list_employee_x_roles/0 returns all employee_x_roles" do
      employee_role = employee_role_fixture()
      assert EmployeexRole.list_employee_x_roles() == [employee_role]
    end

    test "get_employee_role!/1 returns the employee_role with given id" do
      employee_role = employee_role_fixture()
      assert EmployeexRole.get_employee_role!(employee_role.id) == employee_role
    end

    test "create_employee_role/1 with valid data creates a employee_role" do
      valid_attrs = %{}

      assert {:ok, %EmployeeRole{} = employee_role} = EmployeexRole.create_employee_role(valid_attrs)
    end

    test "create_employee_role/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = EmployeexRole.create_employee_role(@invalid_attrs)
    end

    test "update_employee_role/2 with valid data updates the employee_role" do
      employee_role = employee_role_fixture()
      update_attrs = %{}

      assert {:ok, %EmployeeRole{} = employee_role} = EmployeexRole.update_employee_role(employee_role, update_attrs)
    end

    test "update_employee_role/2 with invalid data returns error changeset" do
      employee_role = employee_role_fixture()
      assert {:error, %Ecto.Changeset{}} = EmployeexRole.update_employee_role(employee_role, @invalid_attrs)
      assert employee_role == EmployeexRole.get_employee_role!(employee_role.id)
    end

    test "delete_employee_role/1 deletes the employee_role" do
      employee_role = employee_role_fixture()
      assert {:ok, %EmployeeRole{}} = EmployeexRole.delete_employee_role(employee_role)
      assert_raise Ecto.NoResultsError, fn -> EmployeexRole.get_employee_role!(employee_role.id) end
    end

    test "change_employee_role/1 returns a employee_role changeset" do
      employee_role = employee_role_fixture()
      assert %Ecto.Changeset{} = EmployeexRole.change_employee_role(employee_role)
    end
  end
end
