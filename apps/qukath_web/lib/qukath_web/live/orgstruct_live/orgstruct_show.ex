defmodule QukathWeb.OrgstructLive.OrgstructShow do
  use Surface.LiveView

  alias Surface.Components.Link
  alias Surface.Components.LiveRedirect

  alias Qukath.Orgstructs

  alias QukathWeb.Router.Helpers, as: Routes
  alias QukathWeb.OrgstructLive.NestedOrgstruct
  alias QukathWeb.OrgstructLive.OrgstructFormBulma

  alias QukathWeb.EmployeeLive.EmployeeFormBulma

  import QukathWeb.OrgstructLive.OrgstructIndex, only: [orgstruct_form_cid: 0]
  import QukathWeb.EmployeeLive.EmployeeIndex, only: [employee_form_cid: 0]

  on_mount QukathWeb.AuthUser

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Orgstructs.subscribe()
    {:ok,
      socket
      |> assign(:selected_orgstruct, nil)
      |> assign(:orgstruct, nil)
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
    {:noreply, 
      socket
      |> assign(:selected_orgstruct, selected_orgstruct)
    }
  end

  @impl true
  def handle_event("employee_form", params, socket) do
    EmployeeFormBulma.apply_action(params["action"], params, socket)
    {:noreply, socket}
  end
  


end
