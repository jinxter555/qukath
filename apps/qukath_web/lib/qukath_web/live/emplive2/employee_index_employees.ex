defmodule QukathWeb.EmployeeLive.EmployeeIndexEmployees do
  use Surface.Component

  import QukathWeb.EmployeeLive.EmployeeIndex, only: [employee_form_cid: 0]

  alias Surface.Components.Link


  prop employees, :list, required: true
  # prop employee_attach, :fun, required: true
  prop employee_attach, :fun, default: nil
  prop update_mode, :string, default: "append"
  prop update_id, :string, default: "employees"


  defp hide_deleted(employee, css_class) do
    if employee.__meta__.state == :deleted do
      css_class <> " is-hidden"
    else
      css_class
    end
  end

  defp func_attach(assigns) do
    if assigns.func do
       (assigns.func).(assigns)
    else
       edit_delete(assigns)
    end

  end

  def edit_delete(assigns) do
    ~F"""
    {@employee.name}
    <Link label="Edit" to="#" click="employee_form" values={employee_id: @employee.id, action: :edit, cid: employee_form_cid()} />
    <Link label="Delete" to="#" click="employee_form" values={employee_id: @employee.id, action: :delete} />
    """
  end


end

