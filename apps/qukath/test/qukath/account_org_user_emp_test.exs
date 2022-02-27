defmodule AccountOrgTest do

  use ExUnit.Case
  import Qukath.Factory
  alias Qukath.Accounts
  alias Qukath.Employees
  alias Qukath.Orgstructs
  alias Qukath.Repo
  alias Qukath.Entities
  alias Qukath.Entities.EntityMember

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  @tag :skip
  test "test account user" do
    users = insert_list(3, :user)
    Enum.each(users, fn u ->
      user = Accounts.get_user!(u.id)
      assert u.email == user.email
    end)
  end

  test "test account employee" do
    employees = insert_list(3, :employee)
    Enum.each(employees, fn emp ->
      employee = Employees.get_employee!(emp.id) 
        |> Repo.preload([:user, :entity])
      assert emp.name == employee.name
      assert emp.entity.type == :employee
      assert emp.user.email == employee.user.email
      #org_type = Enum.random([:corporate_group, :company, :department])

      #IO.inspect employee


      #{:ok, o} = Orgstructs.create_orgstruct(%{
      #  employee_id: employee.id,
      #  name: Faker.Company.name(),
      #  type: org_type
      #})
    end)
  end

  @tag :skip
  test "test employees and test orgstruct " do
    :rand.seed(:exsss, {100, 101, 102})

    employees = insert_list(3, :employee)
    Enum.each(employees, fn emp ->
      employee = Employees.get_employee!(emp.id) 
        |> Repo.preload([:user, :entity])
      assert emp.name == employee.name
      assert emp.entity.type == :employee
      assert emp.user.email == employee.user.email

      org_type = Enum.random([:corporate_group, :company, :department])
      #IO.inspect "org_type: #{org_type}"

      {:ok, o} = Orgstructs.create_orgstruct(%{
        employee_id: employee.id,
        name: Faker.Company.name(),
        type: org_type
      })
      orgstruct = Orgstructs.get_orgstruct!(o.id)
      assert orgstruct.type == org_type
    end)
  end

  @tag :skip
  test "test orgstruct company" do
    companies = insert_list(3, :company)
    Enum.each(companies, fn c ->
      company = Orgstructs.get_orgstruct!(c.id) |> Repo.preload([:entity])
      assert c.name == company.name
      assert c.entity.type == :org
      assert c.type == :company
    end)
  end

  @tag :skip
  test "test orgstruct team" do
    team = insert(:team)
    employees = insert_list(3, :employee)

    e_e_ids = Enum.each(employees, fn emp -> 
      employee = Employees.get_employee!(emp.id) 
      assert {:ok, %EntityMember{} = _entity_member} = 
        Entities.create_entity_member(%{
          entity_id: team.entity_id, 
          member_id: employee.entity_id})
        employee.entity_id
    end)

    team_members = Entities.list_entity_members(team.entity_id)

    t_m_ids = Enum.each(team_members, fn member ->
      member.entity_id
    end)

    assert e_e_ids == t_m_ids

    team_loaded = 
      Entities.get_entity!(team.entity_id) |> Repo.preload([:members])

    t_m_loaded_ids = Enum.each(team_loaded.members, fn member ->
      member.entity_id
    end)

    assert e_e_ids == t_m_loaded_ids

  end
end

