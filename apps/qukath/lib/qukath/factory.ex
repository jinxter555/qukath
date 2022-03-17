defmodule Qukath.Factory do

  # without Ecto
  use ExMachina.Ecto, repo: Qukath.Repo

  alias Qukath.Entities.Entity
  alias Qukath.Entities.EntityMember
  alias Qukath.Accounts.User
  alias Qukath.Organizations.Employee
  alias Qukath.Organizations.Orgstruct
  alias Qukath.Roles.Role
  alias Qukath.Work.Todo
  alias Qukath.Work.{TodoInfo, TodoSholder, TodoState}
  alias Qukath.Roles.EmployeeRole


  def user_factory do
    email = sequence(:email, &"email-#{&1}@example.com", start_at: 40)

    %User{
      email: email,
      password: "12345678",
      hashed_password: "12345678",
      # password_confirmation: "12345678"
    }
  end

  def entity_factory do
    %Entity {
    }
  end

  def entity_member_factory do
    %EntityMember {
    }
  end

  def orgstruct_factory do
    %Orgstruct {
      name: Faker.Company.name(),
      type: :company,
      # leader_entity: build(:entity, %{type: :employee}),
      entity: build(:entity, %{type: :org}),
    }
  end

  def company_factory do
    %Orgstruct {
      name: Faker.Company.name(),
      type: :company,
      entity: build(:entity, %{type: :org}),
    }
  end

  def department_factory do
    %Orgstruct {
      name: Faker.Company.name(),
      type: :department,
      entity: build(:entity, %{type: :org}),
    }
  end

  def team_factory do
    %Orgstruct {
      name: Faker.Company.name(),
      type: :team,
      entity: build(:entity, %{type: :org}),
    }
  end

  def employee_factory do
    # name = sequence(:name, &"email-#{&1}@example.com")         
    %Employee {
      name: Faker.Person.name(),
      user: build(:user),
      entity: build(:entity, %{type: :employee}),
    }
  end

  def role_factory do
    orgstruct = insert(:orgstruct)
    %Role {
      name: Faker.Person.title(),
      entity: build(:entity, %{type: :role}),
      orgstruct: orgstruct,
    }
  end

  def employee_role_factory do
    orgstruct = insert(:orgstruct)
    employee = insert(:employee)
    role = insert(:role)
    %EmployeeRole {
      entity: insert(:entity, %{type: :employee_role}),
      employee: employee,
      role: role,
      orgstruct: orgstruct,
    }
  end



  def todo_factory do
    orgstruct = insert(:orgstruct)
    %Todo {
      #name: Faker.Lorem.word(),
      #description: Faker.Lorem.sentence(),
      orgstruct_id:  orgstruct.id,
      entity: build(:entity, %{type: :todo}),
    }
  end

  def todo_info_factory do
    todo = insert(:todo)
    %TodoInfo{
      todo_id: todo.id,
      dependency: Faker.Lorem.sentence(),
      name: Faker.Lorem.word(),
      description: Faker.Lorem.sentence(),
      required_approval:  false
    }
  end

  def todo_sholder_factory do
    todo = insert(:todo)
    employee_role = insert(:employee_role)
    %TodoSholder{
      todo_id: todo.id,
      approved: :wait,
      type: :owner,
      entity: employee_role.entity
    }
  end

  def todo_state_factory do
    todo = insert(:todo)
    %TodoState{
      todo_id: todo.id,
    }
  end

end
