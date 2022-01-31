defmodule Qukath.OrganizationsTest do
  use Qukath.DataCase

  import Qukath.Factory

  alias Qukath.Employees

  # @tag :skip
  describe "employees" do
    alias Qukath.Organizations.Employee

    import Qukath.OrganizationsFixtures

    @invalid_attrs %{name: nil, orgstruct_id: nil}

    # @tag :skip
    test "list_employees/0 returns all employees" do
      employee = employee_fixture()
                 |> forget(:entity) 
                 |> forget(:user) 
      assert Employees.list_employees() == [employee]
    end

    # @tag :skip
    test "get_employee!/1 returns the employee with given id" do
      employee = employee_fixture()
                 |> forget(:entity) 
                 |> forget(:user) 
      assert Employees.get_employee!(employee.id) == employee
    end

    # @tag :skip
    test "create_employee/1 with valid data creates a employee" do
      orgstruct = orgstruct_fixture(:orgstruct)
      valid_attrs = %{
        name: Faker.Person.name(),
        orgstruct_id: orgstruct.id,
      }

      assert {:ok, %Employee{} = employee} = Employees.create_employee(valid_attrs)  
      assert employee.name == valid_attrs.name

    end

    # @tag :skip
    test "create_employee/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Employees.create_employee(@invalid_attrs)
      #IO.inspect Employees.create_employee(@invalid_attrs)
    end

    # @tag :skip
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
                 |> forget(:entity) 
                 |> forget(:user) 
      assert {:error, %Ecto.Changeset{}} = Employees.update_employee(employee, @invalid_attrs)
      assert employee == Employees.get_employee!(employee.id)
    end

    # @tag :skip
    test "delete_employee/1 deletes the employee" do
      employee = employee_fixture()
      assert {:ok, %Employee{}} = Employees.delete_employee(employee)
      assert_raise Ecto.NoResultsError, fn -> Employees.get_employee!(employee.id) end
    end

    # @tag :skip
    test "change_employee/1 returns a employee changeset" do
      employee = employee_fixture()
      assert %Ecto.Changeset{} = Employees.change_employee(employee)
    end
  end

  # @tag :skip
  describe "orgstructs" do
    alias Qukath.Orgstructs
    alias Qukath.Organizations.Orgstruct

    import Qukath.OrganizationsFixtures

    @invalid_attrs %{name: nil, type: nil, leader_entity_id: nil}

    # @tag :skip
    test "list_orgstructs/0 returns all orgstructs" do
      orgstruct = orgstruct_fixture() |> forget(:entity)
      assert Orgstructs.list_orgstructs() == [orgstruct]
    end

    # @tag :skip
    test "get_orgstruct!/1 returns the orgstruct with given id" do
      # orgstruct = orgstruct_fixture()
      orgstruct = insert(:orgstruct) |> forget(:entity)
      assert Orgstructs.get_orgstruct!(orgstruct.id) == orgstruct
    end

    # @tag :skip
    test "create_orgstruct/1 with valid data creates a orgstruct" do
      leader = employee_fixture()
      valid_attrs = %{name: "some name", type: :team, leader_entity_id: leader.entity_id}

      assert {:ok, %Orgstruct{} = orgstruct} = Orgstructs.create_orgstruct(valid_attrs)
      assert orgstruct.name == "some name"
      assert orgstruct.type == :team
    end

    # @tag :skip
    test "create_orgstruct_init/2 with user arg " do
      user = insert(:user)

      valid_attrs = %{name: "some name", type: :team}

      assert {:ok, %Orgstruct{} = orgstruct} = Orgstructs.create_orgstruct_init(user.id, valid_attrs, "bob's world")
      # employee = Employees.get_employee_by_user_id!(user.id) |> hd

      employee = Employees.get_employee_by_user_orgstruct_ids!(user.id, orgstruct.id)|> hd
      
      #IO.inspect orgstruct
      #IO.inspect user
      #IO.inspect employee

      assert orgstruct.name == "some name"
      assert orgstruct.type == :team
      assert orgstruct.leader_entity_id == employee.entity_id
    end

    # @tag :skip
    test "create_orgstruct/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orgstructs.create_orgstruct(@invalid_attrs)
    end

    # @tag :skip
    test "update_orgstruct/2 with valid data updates the orgstruct" do
      orgstruct = orgstruct_fixture()
      leader = employee_fixture()
      update_attrs = %{name: "some updated name", type: :company, leader_entity_id: leader.entity_id}

      assert {:ok, %Orgstruct{} = orgstruct} = Orgstructs.update_orgstruct(orgstruct, update_attrs)
      assert orgstruct.name == "some updated name"
      assert orgstruct.type == :company
    end

    # @tag :skip
    test "update_orgstruct/2 with invalid data returns error changeset" do
      orgstruct = orgstruct_fixture()
                 |> forget(:entity) 
      assert {:error, %Ecto.Changeset{}} = Orgstructs.update_orgstruct(orgstruct, @invalid_attrs)
      assert orgstruct == Orgstructs.get_orgstruct!(orgstruct.id)
    end

    # @tag :skip
    test "delete_orgstruct/1 deletes the orgstruct" do
      orgstruct = orgstruct_fixture()
      assert {:ok, %Orgstruct{}} = Orgstructs.delete_orgstruct(orgstruct)
      assert_raise Ecto.NoResultsError, fn -> Orgstructs.get_orgstruct!(orgstruct.id) end
    end

    # @tag :skip
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
