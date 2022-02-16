defmodule QukathWeb.OrgstructLive.Members do
  use Surface.LiveView

  alias Phoenix.LiveView.JS

  alias Qukath.Employees
  alias Qukath.Orgstructs
  #alias Qukath.Orgemp
  #alias QukathWeb.EmployeeLive.EmployeeFormBulma
  alias QukathWeb.EmployeeLive.EmployeeIndexEmployees
  alias Surface.Components.{Link ,LiveRedirect}
  alias QukathWeb.OrgstructLive.NestedOrgstruct

  alias QukathWeb.Router.Helpers, as: Routes

  #import QukathWeb.ExtraHelper, only: [hide_deleted: 2]

  on_mount QukathWeb.AuthUser

  @page_size 3

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Employees.subscribe()
    {:ok, socket
    |> assign(:tgt_members, [])
    |> assign(:src_members, [])
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
      apply_action(socket, socket.assigns.live_action, params)
    }
  end


  defp emp_o_mem_page(:corporate_group, orgstruct, socket) do
    emp_o_mem_page(:company, orgstruct, socket) 
  end

  defp emp_o_mem_page(:company, orgstruct, socket) do
    Employees.list_employees(%{
      "orgstruct_id" => orgstruct.id,
      "except" => socket.assigns.tgt_members |> Enum.map(&(&1.id)),
      "page" => 1,
      "page_size" => @page_size,
    })
  end

  defp emp_o_mem_page(_, orgstruct, _) do
    Employees.list_employee_members(%{
      "page" => 1,
      "page_size" => @page_size,
      "orgstruct_id" => orgstruct.id})
  end

  @impl true
  def handle_event("src_orgstruct", params, socket) do
    src_orgstruct = Orgstructs.get_orgstruct!(params["orgstruct-id"])
    page = emp_o_mem_page(src_orgstruct.type, src_orgstruct, socket)

    {:noreply, socket
    |> assign(src_members: page.entries)
    |> assign(page: page)
    }
  end

  @impl true
  def handle_event("tgt_orgstruct", params, socket) do
    tgt_members = Employees.list_employee_members(%{
      "orgstruct_id" => params["orgstruct-id"]})
    {:noreply, socket
    |> assign(tgt_members: tgt_members)
    }
  end
  
  defp apply_action(socket, :add_members, params ) do
    orgstruct = Orgstructs.get_orgstruct!(params["id"])
    src_nested_orgstruct = Orgstructs.build_nested_orgstruct(orgstruct.id)
    tgt_nested_orgstruct = Orgstructs.build_nested_orgstruct(orgstruct.id)

    socket 
    |> assign(:orgstruct, orgstruct)
    |> assign(:src_nested_orgstruct, src_nested_orgstruct)
    |> assign(:tgt_nested_orgstruct, tgt_nested_orgstruct)
    |> assign(:page, nil)
  end

  def src_func(assigns) do
    ~F"""
    <Link label={@orgstruct.name} to="#" click="src_orgstruct" values={orgstruct_id: @orgstruct.id}/><br/>
    """
  end

  def tgt_func(assigns) do
    ~F"""
    <Link label={@orgstruct.name} to="#" click="tgt_orgstruct" values={orgstruct_id: @orgstruct.id}/><br/>
    """
  end
end
