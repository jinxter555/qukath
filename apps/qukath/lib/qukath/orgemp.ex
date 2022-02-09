defmodule Qukath.Orgemp do
  #alias Qukath.Entities.Entity
  #alias Qukath.Entities.EntityMember

  alias Qukath.Orgstructs
  alias Qukath.Employees
  alias Qukath.Entities
  alias Qukath.Repo

  def add_employee_to_orgstruct(employee_id, orgstruct_id) do
    employee = Employees.get_employee!(employee_id) |> Repo.preload([:entity])
    orgstruct = Orgstructs.get_orgstruct!(orgstruct_id) |> Repo.preload([:entity])

    result_exist = Entities.get_entity_member!(
      orgstruct.entity.id,
      employee.entity.id)

    if length(result_exist) > 0 do
      hd result_exist
    else
      Entities.create_entity_member(%{
        entity_id: orgstruct.entity.id,
        member_id: employee.entity.id })
    end
  end

  def employee_orgstruct_action("add", params, socket) do
    IO.puts "employee_orgstruct_action"
    IO.inspect params
    add_employee_to_orgstruct(
      params["employee-id"], 
      socket.assigns.selected_orgstruct.id)

  end

end

