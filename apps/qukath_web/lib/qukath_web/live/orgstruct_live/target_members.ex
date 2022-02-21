defmodule QukathWeb.OrgstructLive.TargetMembers do
  use Surface.LiveComponent

  alias Phoenix.LiveView.JS

  alias Qukath.Employees
  alias Qukath.Orgstructs
  alias QukathWeb.EmployeeLive.EmployeeIndexEmployees
  alias Surface.Components.{Link} # ,LiveRedirect}
  #alias QukathWeb.OrgstructLive.NestedOrgstruct

  #alias QukathWeb.Router.Helpers, as: Routes

  #import QukathWeb.ExtraHelper, only: [hide_deleted: 2]
  @page_size 3

  prop orgstruct, :any, default: nil 
  prop func, :fun, default: nil 
  data page, :any, default: %Scrivener.Page{total_pages: 0}



  def render(assigns) do
    assigns = if Map.has_key?(assigns, :page), do: assigns,        # not sure why page
    else: Map.put(assigns, :page, %Scrivener.Page{total_pages: 0}) # doesn't exist in assigns
    ~F"""
    <div>
      {#for n <- 1..@page.total_pages}
        <Link label={n} to="#" click="member_page" values={page: n} />
      {/for}

      <EmployeeIndexEmployees 
        employees={@page.entries}
        update_mode="replace"
        update_id="target_member"
        :let={employee: employee,
        item_id: _item_id}>
    
        <Link label={employee.name} to="#" click={
          JS.push("orgstruct_employee",
          value: %{employee_id: employee.id, action: :delete})} />

      </EmployeeIndexEmployees>
    </div>
    """
          #JS.hide(to: "#" <> item_id) |> JS.show(to: "#" <> "source_member-" <> item_id) |>
  end

  #####################
  @impl true
  def mount(socket) do
    {:ok, socket
    }
  end


  def update(assigns, socket) do
    IO.puts "in update target_member"

    
    socket = %{socket | assigns: Map.merge(socket.assigns, assigns)}
    page = emp_o_mem_page(
      socket.assigns.orgstruct.type, 
      socket.assigns.orgstruct, socket, %{})

    #IO.inspect socket
    #IO.inspect assigns
    #IO.inspect length(page.entries)
    #IO.puts "---------"
    {:ok, socket
    |> assign(:page, page)
    }
  end

  #####################
  @impl true
  def handle_event("member_page", params, socket) do
    #IO.puts "in member_page target_member"
    orgstruct = socket.assigns.orgstruct
    page = emp_o_mem_page(orgstruct.type, orgstruct, socket, params)
    {:noreply, socket |> assign(page: page) }
  end

  @impl true
  def handle_event("orgstruct_employee", params, socket) do
    IO.puts "in orgstruct_employee target_member"
    Orgstructs.delete_orgstruct_member(
      socket.assigns.orgstruct.id,
      params["employee_id"])

    orgstruct = socket.assigns.orgstruct
    page = emp_o_mem_page(orgstruct.type, orgstruct, socket, params)

    if socket.assigns.func do
       (socket.assigns.func).(socket, params)
    end
    {:noreply, socket |> assign(page: page) }
  end


  #####################
  defp emp_o_mem_page(:corporate_group, orgstruct, socket, params) do
    emp_o_mem_page(:company, orgstruct, socket, params) 
  end

  defp emp_o_mem_page(:company, orgstruct, _socket, params) do
    Employees.list_employees(%{
      "orgstruct_id" => orgstruct.id,
      "page" => params["page"] || 1,
      "page_size" => @page_size,
    })
  end

  defp emp_o_mem_page(_, orgstruct, _socket, params) do
    Employees.list_employee_members(%{
      "page" => params["page"] || 1,
      "page_size" => @page_size,
      "orgstruct_id" => orgstruct.id})
  end

end
