defmodule QukathWeb.OrgstructLive.OrgstructShow do
  use Surface.LiveView

  alias Surface.Components.Link
  alias Surface.Components.LiveRedirect

  alias Qukath.Orgstructs
  alias Qukath.Employees
  alias Qukath.Orgemp

  alias QukathWeb.Router.Helpers, as: Routes
  alias QukathWeb.OrgstructLive.NestedOrgstruct
  alias QukathWeb.OrgstructLive.OrgstructFormBulma

  alias QukathWeb.EmployeeLive.EmployeeFormBulma
  alias QukathWeb.EmployeeLive.EmployeeIndexEmployees

  import QukathWeb.OrgstructLive.OrgstructIndex, only: [orgstruct_form_cid: 0]
  import QukathWeb.EmployeeLive.EmployeeIndex, only: [employee_form_cid: 0]

  on_mount QukathWeb.AuthUser

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Orgstructs.subscribe()
    {:ok,
      socket
      |> assign(:selected_orgstruct, nil)
      |> assign(:employees, [])
      |> assign(:members, [])
      |> assign(:orgstruct, nil),
      temporary_assigns: [members: []]
    }
  end
    
  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
      apply_action(socket, socket.assigns.live_action, params)
    }
  end

  defp apply_action(socket, :show, params) do    
    orgstruct = Orgstructs.get_orgstruct!(params["id"])
    nested_orgstruct = Orgstructs.build_nested_orgstruct(orgstruct.id)
    socket    
    |> assign(:orgstruct, orgstruct)
    |> assign(:selected_orgstruct, orgstruct)
    |> assign(:nested_orgstruct, nested_orgstruct)
  end    

  @impl true
  def handle_event("orgstruct_form", params, socket) do
    OrgstructFormBulma.apply_action(params["action"], params, socket)
    {:noreply, socket}
  end
  
  @impl true
  def handle_event("select_orgstruct", params, socket) do
    IO.inspect "select_orgstruct"

    selected_orgstruct = Orgstructs.get_orgstruct!(params["selected-orgstruct-id"])

    IO.inspect selected_orgstruct

    employees = Employees.list_employees(%{"orgstruct_id" => socket.assigns.orgstruct.id})
    members = Employees.list_employee_members(%{"orgstruct_id" => selected_orgstruct.id})

    IO.inspect employees
    IO.puts "---------------------"
    IO.inspect members

    {:noreply, 
      socket
      |> assign(:employees, employees)
      |> assign(:members, members)
      |> assign(:selected_orgstruct, selected_orgstruct)
    }
  end

  @impl true
  def handle_event("employee_form", params, socket) do
    EmployeeFormBulma.apply_action(params["action"], params, socket)
    {:noreply, socket}
  end

  @impl true
  def handle_event("orgstruct_employee", params, socket) do
    IO.puts "orgstruct_employee"
    #IO.inspect params
    #IO.inspect socket.assigns.selected_orgstruct
    Orgemp.employee_orgstruct_action(params["action"], params, socket)
    {:noreply, socket}
  end
  
  defp add_emp_to_org(assigns) do
    ~F"""
    <Link label="Add" to="#" click="orgstruct_employee" values={employee_id: @employee_id, action: :add} />
    <!-- Link label="Remove" to="#" click="orgstruct_employee" values={employee_id: @employee_id, action: :remove} / -->
    """
  end

   defp remove_emp_to_org(assigns) do
    ~F"""
    <Link label="Remove" to="#" click="orgstruct_employee" values={employee_id: @employee_id, action: :remove} />
    """
  end

end
