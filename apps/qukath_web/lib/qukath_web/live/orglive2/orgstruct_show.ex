defmodule QukathWeb.OrgstructLive.OrgstructShow do
  use Surface.LiveView

  alias Surface.Components.Link
  alias Surface.Components.LiveRedirect
  alias SurfaceBulma.Form.{HiddenInput}

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
      |> assign(:hide_members_component, "")
      |> assign(:update_mode, "replace")
      |> assign(:orgstruct, nil) , temporary_assigns: [members: []]
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
    selected_orgstruct = Orgstructs.get_orgstruct!(params["selected-orgstruct-id"])
    employees = Employees.list_employees(%{"orgstruct_id" => socket.assigns.orgstruct.id})
    members = Employees.list_employee_members(%{"orgstruct_id" => selected_orgstruct.id})
    hide_members_component = if members == [], do: "is-hidden", else: ""

    {:noreply, 
      socket
      |> assign(:employees, employees)
      |> assign(:members, members)
      |> assign(:hide_members_component, hide_members_component)
      |> assign(:update_mode, "replace")
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
    Orgemp.employee_orgstruct_action(params["action"], params, socket)
    {:noreply, socket}
  end
  
  defp add_emp_to_org(assigns) do
    ~F"""
    {@employee.name}
    <Link label="Add" to="#" click="orgstruct_employee" values={employee_id: @employee.id, action: :add} />
    """
  end

   defp remove_emp_to_org(assigns) do
    ~F"""
    {@employee.name}
    <Link label="Remove" to="#" click="orgstruct_employee" values={employee_id: @employee.id, action: :remove} />
    """
  end

  defp hide_empty("replace", []) do
    IO.puts "empty replace"
    "is-hidden"

  end
  defp hide_empty(m, l) do
    IO.inspect m
    IO.inspect length(l)
    ""
  end

end
