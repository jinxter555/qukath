defmodule Qukath.OrganizationsTest do
  use Qukath.DataCase

  import Qukath.Factory

  describe "employees" do
    alias Qukath.Employees
    alias Qukath.Repo
    alias Qukath.Organizations.Employee

    import Qukath.OrganizationsFixtures

    @invalid_attrs %{name: nil, orgstruct_id: nil}

    @tag :skip
    test "list_employees/0 returns all employees" do
      employee = employee_fixture()
                 |> forget(:entity) 
                 |> forget(:user) 
      assert Employees.list_employees() == [employee]
    end

    @tag :skip
    test "get_employee!/1 returns the employee with given id" do
      employee = employee_fixture()
                 |> forget(:entity) 
                 |> forget(:user) 
      assert Employees.get_employee!(employee.id) == employee
    end

    @tag :skip
    test "create_employee/1 with valid data creates a employee" do
      orgstruct = orgstruct_fixture(:orgstruct)
      valid_attrs = %{
        name: Faker.Person.name(),
        orgstruct_id: orgstruct.id,
      }

      assert {:ok, %Employee{} = employee} = Employees.create_employee(valid_attrs)  
      assert employee.name == valid_attrs.name

    end

    @tag :skip
    test "create_employee/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Employees.create_employee(@invalid_attrs)
      #IO.inspect Employees.create_employee(@invalid_attrs)
    end

    @tag :skip
    test "update_employee/2 with valid data updates the employee" do
      employee = employee_fixture()
      orgstruct = orgstruct_fixture()
      update_attrs = %{name: "some updated name", orgstruct_id: orgstruct.id}

      assert {:ok, %Employee{} = employee} = Employees.update_employee(employee, update_attrs)
      assert employee.name == "some updated name"
    end

    # @tag :skip
    test "update_employee/2 with invalid data returns error changeset" do
      employee = employee_fixture()
      assert {:error, %Ecto.Changeset{}} = Employees.update_employee(employee, @invalid_attrs)
      assert employee == Employees.get_employee!(employee.id)
    end

    @tag :skip
    test "delete_employee/1 deletes the employee" do
      employee = employee_fixture()
      assert {:ok, %Employee{}} = Employees.delete_employee(employee)
      assert_raise Ecto.NoResultsError, fn -> Employees.get_employee!(employee.id) end
    end

    @tag :skip
    test "change_employee/1 returns a employee changeset" do
      employee = employee_fixture()
      assert %Ecto.Changeset{} = Employees.change_employee(employee)
    end
  end

  @tag :skip
  describe "orgstructs" do
    alias Qukath.Orgstructs
    alias Qukath.Organizations.Orgstruct

    import Qukath.OrganizationsFixtures

    @invalid_attrs %{name: nil, type: nil}

    test "list_orgstructs/0 returns all orgstructs" do
      orgstruct = orgstruct_fixture()
      assert Orgstructs.list_orgstructs() == [orgstruct]
    end

    @tag :skip
    test "get_orgstruct!/1 returns the orgstruct with given id" do
      orgstruct = orgstruct_fixture()
      assert Orgstructs.get_orgstruct!(orgstruct.id) == orgstruct
    end

    @tag :skip
    test "create_orgstruct/1 with valid data creates a orgstruct" do
      valid_attrs = %{name: "some name", type: 42}

      assert {:ok, %Orgstruct{} = orgstruct} = Orgstructs.create_orgstruct(valid_attrs)
      assert orgstruct.name == "some name"
      assert orgstruct.type == 42
    end

    @tag :skip
    test "create_orgstruct/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orgstructs.create_orgstruct(@invalid_attrs)
    end

    @tag :skip
    test "update_orgstruct/2 with valid data updates the orgstruct" do
      orgstruct = orgstruct_fixture()
      update_attrs = %{name: "some updated name", type: 43}

      assert {:ok, %Orgstruct{} = orgstruct} = Orgstructs.update_orgstruct(orgstruct, update_attrs)
      assert orgstruct.name == "some updated name"
      assert orgstruct.type == 43
    end

    @tag :skip
    test "update_orgstruct/2 with invalid data returns error changeset" do
      orgstruct = orgstruct_fixture()
      assert {:error, %Ecto.Changeset{}} = Orgstructs.update_orgstruct(orgstruct, @invalid_attrs)
      assert orgstruct == Orgstructs.get_orgstruct!(orgstruct.id)
    end

    @tag :skip
    test "delete_orgstruct/1 deletes the orgstruct" do
      orgstruct = orgstruct_fixture()
      assert {:ok, %Orgstruct{}} = Orgstructs.delete_orgstruct(orgstruct)
      assert_raise Ecto.NoResultsError, fn -> Orgstructs.get_orgstruct!(orgstruct.id) end
    end

    @tag :skip
    test "change_orgstruct/1 returns a orgstruct changeset" do
      orgstruct = orgstruct_fixture()
      assert %Ecto.Changeset{} = Orgstructs.change_orgstruct(orgstruct)
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
