defmodule QukathWeb.EmployeeLive.EmployeeIndexEmployees do
  use Surface.Component

  import QukathWeb.EmployeeLive.EmployeeIndex, only: [employee_form_cid: 0]

  alias Surface.Components.Link


  prop employees, :list, required: true
  slot default, args: [:employee, :item_id]
  prop update_mode, :string, default: "append"
  prop update_id, :string, default: "employee"


  def render(assigns) do
    ~F"""
    <div id={@update_id<>"s"} phx-update={@update_mode}>
      {#for employee <- @employees }
        <div id={item_id = @update_id <> "-" <> "#{employee.id}"} class={hide_deleted(employee, "container")}>
          <#slot :args={employee: employee, item_id: item_id}>
             {employee.name} 
             <Link label="Edit" to="#" click="employee_form" values={employee_id: employee.id, action: :edit, cid: employee_form_cid()} />
             <Link label="Delete" to="#" click="employee_form" values={employee_id: employee.id, action: :delete} />
          </#slot>
        </div>
      {/for}
    </div>
    """
  end

  defp hide_deleted(employee, css_class) do
    if employee.__meta__.state == :deleted do
      css_class <> " is-hidden"
    else
      css_class
    end
  end

end

