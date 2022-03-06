defmodule QukathWeb.EmployeeRolesLive.IndexRoles do
  use Surface.LiveView, layout: {QukathWeb.LayoutView, "live.html"}


  alias Qukath.Orgstructs
  alias Qukath.Organizations.Orgstruct
  alias Qukath.Employees
  alias Qukath.Roles
  alias Qukath.Roles.EmployeeRole
  alias Qukath.EmployeeRoles
  alias QukathWeb.OrgstructLive.NestedOrgstruct
  alias Surface.Components.{Link}

  # alias QukathWeb.Router.Helpers, as: Routes

  @impl true
  def render(assigns) do
    ~F"""
    Add Role for: {@employee.name} <br>
    <div class="columns ">

      <div class="column is-one-fifth">
        <NestedOrgstruct
            nested_orgstruct={@nested_orgstruct}
            selected_orgstruct={@selected_orgstruct}
            socket={@socket} 
            parent_orgstruct={@orgstruct}
            print_parent={true}
            orgfunc={&print_orgstruct/1} />
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
      </div>

      <div class="column is-one-fifth">
        world
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
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:employee, Employees.get_employee!(employee_id))
     |> assign(:orgstruct, orgstruct)
     |> assign(:nested_orgstruct, nested_orgstruct)
     |> assign(:selected_orgstruct, %Orgstruct{})
     |> assign(:roles, roles)
    }
  end
    
  @impl true
  def handle_event("select_orgstruct", params, socket) do
    orgstruct = Orgstructs.get_orgstruct!(params["orgstruct-id"])
    roles = Roles.list_roles(orgstruct_id: orgstruct.id)
    {:noreply, socket
     |> assign(:roles, roles)
     |> assign(selected_orgstruct: orgstruct)
    }
  end

  def handle_event("add_role", params, socket) do
    IO.puts "add_role"
    IO.inspect params
    IO.inspect socket
    EmployeeRoles.create_employee_role(%{
      employee_id: socket.assigns.employee.id,
      role_id: params["role-id"]}) 
    |> case do
      {:ok, _employee_role} -> {:noreply, 
          socket |> put_flash(:info, "employee role created successfully")}
      _ -> {:noreply,
          socket |> put_flash(:error, "employee role create error")}
    end

  end


  defp page_title(:index), do: "index employee roles"
  defp page_title(:show), do: "Show employee roles"
  defp page_title(:edit), do: "Edit employee roles"

  def print_orgstruct(assigns) do
    ~F"""
      <Link label={@orgstruct.name} to="#" click="select_orgstruct" values={ orgstruct_id: @orgstruct.id}
      class={@orgstruct.id == @selected_orgstruct.id && "has-text-primary"}/> <br/>
    """
  end

end
