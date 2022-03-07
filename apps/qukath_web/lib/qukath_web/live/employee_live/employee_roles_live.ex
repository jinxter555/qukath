defmodule QukathWeb.EmployeeRolesLive.IndexRoles do
  use Surface.LiveView, layout: {QukathWeb.LayoutView, "live.html"}


  alias Qukath.Orgstructs
  alias Qukath.Organizations.Orgstruct
  alias Qukath.Employees
  alias Qukath.Roles
  #alias Qukath.Roles.EmployeeRole
  alias Qukath.EmployeeRoles
  alias QukathWeb.OrgstructLive.NestedOrgstructSlot
  alias Surface.Components.{Link}

  # alias QukathWeb.Router.Helpers, as: Routes

  @impl true
  def render(assigns) do
    ~F"""
    Add Role for: {@employee.name} <br>
    <div class="columns ">

      <div class="column is-one-fifth">
        <NestedOrgstructSlot nested_orgstruct={@nested_orgstruct} 
          parent_orgstruct={@orgstruct} print_parent={true} :let={orgstruct: orgstruct_item}>

          <Link label={orgstruct_item.name} to="#" 
            click="select_orgstruct" values={orgstruct_id: orgstruct_item.id}
            class={orgstruct_item.id == @selected_orgstruct.id && "has-text-primary"}/> <br/>

        </NestedOrgstructSlot>
      </div>


      <div class="column ">
        Add roles
        <div id="roles" phx-update="replace">
          {#for role <- @roles }
          <div id={"role-#{role.id}"}>
            <Link label={role.name} to="#" click="add_role" values={ role_id: role.id} />
          </div>
          {/for}
        </div>
      </div>

      <div class="column ">
        Current Roles
        {#for er <- @employee_roles }
        <div id="employee-roles" phx-update="replace">
          <div id={"employee_role-#{er.id}"}>
            <Link label={er.role.name} to="#" click="remove_role" values={ er_id: er.id} />
          </div>
        </div>
        {/for}
      </div>

      <div class="column is-one-fifth">
      </div>
    </div>
    
    """
  end

   @impl true
  def handle_params(%{"employee_id" => employee_id} = _params, _url, socket) do
    employee = Employees.get_employee!(employee_id)
    orgstruct = Orgstructs.get_orgstruct!(employee.orgstruct_id)
    nested_orgstruct = Orgstructs.build_nested_orgstruct(employee.orgstruct_id)
    roles = Roles.list_roles(orgstruct_id: orgstruct.id)
    employee_roles = EmployeeRoles.list_employee_roles(%{"employee_id" => employee.id})
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:employee, Employees.get_employee!(employee_id))
     |> assign(:orgstruct, orgstruct)
     |> assign(:nested_orgstruct, nested_orgstruct)
     |> assign(:selected_orgstruct, %Orgstruct{})
     |> assign(:roles, roles)
     |> assign(:employee_roles, employee_roles)
    }
  end
    
  @impl true
  def handle_event("select_orgstruct", params, socket) do
    orgstruct = Orgstructs.get_orgstruct!(params["orgstruct-id"])
    roles = Roles.list_roles(orgstruct_id: orgstruct.id)
    {:noreply, socket
     |> assign(:roles, roles)
     |> assign(:selected_orgstruct, orgstruct)
    }
  end

  def handle_event("add_role", params, socket) do
    EmployeeRoles.create_employee_role(%{
      employee_id: socket.assigns.employee.id,
      role_id: params["role-id"]}) 
    |> case do
      {:ok, er} -> {:noreply, socket
          |> assign(:employee_roles, EmployeeRoles.list_employee_roles(%{"employee_id" => er.employee_id}))
          |> put_flash(:info, "employee role created successfully")}
      _ -> {:noreply,
          socket |> put_flash(:error, "employee role create error")}
    end
  end

  def handle_event("remove_role", params, socket) do
    employee_role = EmployeeRoles.get_employee_role!(params["er-id"])
    EmployeeRoles.delete_employee_role(employee_role)
    |> case do
      {:ok, er} -> {:noreply, socket 
          |> assign(:employee_roles, EmployeeRoles.list_employee_roles(%{"employee_id" => er.employee_id}))
          |> put_flash(:info, "employee role deleted successfully")}
      _ -> {:noreply,
          socket |> put_flash(:error, "employee role deleted error")}
    end
  end


  defp page_title(:index), do: "index employee roles"
  defp page_title(:show), do: "Show employee roles"
  defp page_title(:edit), do: "Edit employee roles"

end
