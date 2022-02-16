defmodule QukathWeb.OrgstructLive.Members do
  use Surface.LiveView

  alias Phoenix.LiveView.JS

  alias Qukath.Employees
  alias Qukath.Orgstructs
  alias Qukath.Orgemp
  #alias QukathWeb.EmployeeLive.EmployeeFormBulma
  alias QukathWeb.EmployeeLive.EmployeeIndexEmployees
  alias Surface.Components.{Link} # ,LiveRedirect}
  alias QukathWeb.OrgstructLive.NestedOrgstruct

  #alias QukathWeb.Router.Helpers, as: Routes

  #import QukathWeb.ExtraHelper, only: [hide_deleted: 2]

  on_mount QukathWeb.AuthUser

  @page_size 3

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Employees.subscribe()
    {:ok, socket
    |> assign(:tgt_page, %Scrivener.Page{})
    |> assign(:src_page, %Scrivener.Page{})
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
      apply_action(socket, socket.assigns.live_action, params)
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
  end

  defp emp_o_mem_page(:corporate_group, orgstruct, socket) do
    emp_o_mem_page(:company, orgstruct, socket) 
  end

  defp emp_o_mem_page(:company, orgstruct, socket) do
    Employees.list_employees(%{
      "orgstruct_id" => orgstruct.id,
      "except" => socket.assigns.tgt_page.entries |> Enum.map(&(&1.id)),
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
    |> assign(src_page: page)
    }
  end

  @impl true
  def handle_event("tgt_orgstruct", params, socket) do
    tgt_orgstruct = Orgstructs.get_orgstruct!(params["orgstruct-id"])
    page = emp_o_mem_page(tgt_orgstruct.type, tgt_orgstruct, socket)
    {:noreply, socket
    |> assign(tgt_page: page)
    |> assign(:tgt_orgstruct_id, tgt_orgstruct.id) # Orgemp actions
    }
  end
  
  #####################
  @impl true
  def handle_event("orgstruct_employee", params, socket) do
    if(socket.assigns.tgt_page != %Scrivener.Page{} ) do # target hasn't been selected?
      {members_src, members_tgt} = members_action(params["action"], socket, params["employee_id"])
      Orgemp.employee_orgstruct_action(params["action"], params, socket)

      src_page = Map.replace(socket.assigns.src_page, :entries, members_src)
      tgt_page = Map.replace(socket.assigns.tgt_page, :entries, members_tgt)

      {:noreply, socket
        |>assign(:src_page, src_page)
        |>assign(:tgt_page, tgt_page) }
    else
      {:noreply, socket}
    end
  end

  defp members_action("add", socket, employee_id) do
    members_src = socket.assigns.src_page.entries
    members_tgt = socket.assigns.tgt_page.entries

    added_member = Enum.find(members_src, fn m ->
      m.id == employee_id
    end)

    {Enum.filter(members_src, fn m ->
      m.id != employee_id
    end),
    List.flatten([members_tgt , added_member]) }
  end

  defp members_action("remove", socket, employee_id) do
    members_src = socket.assigns.src_page.entries
    members_tgt = socket.assigns.tgt_page.entries

    removed_member = Enum.find(members_tgt, fn m ->
      m.id == employee_id
    end)

    {List.flatten([members_src , removed_member]),
    Enum.filter(members_tgt, fn m ->
      m.id != employee_id
    end)}

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
