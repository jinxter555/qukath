defmodule QukathWeb.RoleLive.SelectEmployeeRoles do
  use Surface.LiveComponent

  #alias Qukath.Roles
  alias Qukath.EmployeeRoles
  alias Qukath.Entities
  alias Qukath.Orgstructs
  alias Qukath.Organizations.Orgstruct
  #alias QukathWeb.RoleLive.RoleFormBulma
  #alias Surface.Components.{Link,LiveRedirect}
  #alias QukathWeb.Router.Helpers, as: Routes
  alias SurfaceBulma.Dropdown  
  alias SurfaceBulma.Modal.{Card, Header, Footer}
  alias Surface.Components.Link


  import QukathWeb.ExtraHelper, only: [merge_socket_assigns: 2]
  prop orgstruct, :any, required: true
  data show, :boolean, default: false
  data show_dd, :boolean, default: false
  data employee_roles, :list, default: []
  data ancestor_orgstruct, :any, default: nil
  data orgstruct_list, :list, default: []


  def render(assigns) do
    ~F"""
    <Card show={@show} close_event="modal_close" show_close_button={true} class="container is-max-desktop">

      <Header >
        Assign Role show_dd: {@show_dd}
      </Header>

    <Dropdown active={@show_dd} id="serhdd01" >
      <:trigger>{@orgstruct.name}</:trigger>
      <div class="dropdown-menu" id="dropdown-menu" role="menu" >
        <div class="dropdown-content">

       {#for org <- @orgstruct_list }
          <Link label={org.name} to="#" click="select_orgstruct"
             values={selected_orgstruct_id: org.id} class={"dropdown-item" <> active_orgstruct(org.id, @orgstruct.id)} />
       {/for}
        </div>
      </div>
    </Dropdown> <br>


    {#for er <- @employee_roles}
      {er.role.name}: {er.employee.name} <br>
    {/for}

    </Card>


    """
  end

  def mount(socket) do
    {:ok, socket
      |> assign(:orgstruct, %Orgstruct{name: ""})
    }
  end

  def update(assigns, socket) do
    socket = merge_socket_assigns(socket, assigns)
    ancestor_orgstruct = Entities.get_ancestor_struct(socket.assigns.orgstruct.entity_id)
    orgstruct_list = Orgstructs.list_descendants(ancestor_orgstruct.id)

    {:ok, socket
    |> assign(:ancestor_orgstruct, ancestor_orgstruct)
    |> assign(:orgstruct_list, orgstruct_list)
    |> assign(:employee_roles, EmployeeRoles.list_employee_roles(orgstruct_id: socket.assigns.orgstruct.id))
    }
 end

  def apply_action(_, _params, _parent_socket) do
    send_update(__MODULE__,
      id: "ser01",
      show: true)
  end

  @impl true
  def handle_event("modal_close", _params, socket) do

    {:noreply, assign(socket, show: false)}
  end

  @impl true
  def handle_event("select_orgstruct", params, socket) do
    orgstruct = Orgstructs.get_orgstruct!(params["selected-orgstruct-id"])
    {:noreply, socket 
    |> assign(orgstruct: orgstruct)
    # |> assign(:show_dd, !socket.assigns.show_dd)
    |> assign(:employee_roles, EmployeeRoles.list_employee_roles(orgstruct_id: orgstruct.id))
    }
  end

  defp active_orgstruct(orgstruct1, orgstruct2) when orgstruct1 == orgstruct2, do: " is-active"  
  defp active_orgstruct(_, _),  do: " "

end

