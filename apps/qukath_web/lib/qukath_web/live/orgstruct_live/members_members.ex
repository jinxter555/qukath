defmodule QukathWeb.OrgstructLive.MembersMembers do
  use Surface.LiveComponent

  #alias Phoenix.LiveView.JS

  alias Qukath.Employees
  #alias Qukath.Orgstructs
  #alias Qukath.Orgemp
  #alias QukathWeb.EmployeeLive.EmployeeFormBulma
  alias QukathWeb.EmployeeLive.EmployeeIndexEmployees
  alias Surface.Components.{Link} # ,LiveRedirect}
  #alias QukathWeb.OrgstructLive.NestedOrgstruct

  #alias QukathWeb.Router.Helpers, as: Routes

  #import QukathWeb.ExtraHelper, only: [hide_deleted: 2]
  #alias SurfaceBulma.Button
  @page_size 3

  prop orgstruct, :any, default: nil 
  prop func, :fun, default: nil 
  data page, :any, default: nil



  def render(assigns) do
    ~F"""
    <div>
      {#if @page && @page.total_pages} page:
        {#for n <- 1..@page.total_pages}
          <Link label={n} to="#" click="member_page" values={page: n} />
        {/for}
      {/if}

     <EmployeeIndexEmployees employees={@page.entries} update_mode="replace" update_id="member" :let={employee: employee}>
       <Link label={employee.name} to="#" click="orgstruct_employee" values={employee_id: employee.id} />
     </EmployeeIndexEmployees>

    </div>
    """
  end

  #####################
  @impl true
  def mount(socket) do
    {:ok, socket
    |> assign(:page, %Scrivener.Page{})
    }
  end

  def update(assigns, socket) do
    socket = %{socket | assigns: Map.merge(socket.assigns, assigns)}
    page = emp_o_mem_page(assigns.orgstruct.type, assigns.orgstruct, socket, %{})
    {:ok, socket
    |> assign(:page, page)
    }
  end

  #####################
  @impl true
  def handle_event("member_page", params, socket) do
    orgstruct = socket.assigns.orgstruct
    page = emp_o_mem_page(orgstruct.type, orgstruct, socket, params)
    {:noreply, socket |> assign(page: page) }
  end

  @impl true
  def handle_event("orgstruct_employee", params, socket) do
    if socket.assigns.func do
       (socket.assigns.func).(socket, params)
    end
    {:noreply, socket }
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
