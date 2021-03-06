defmodule QukathWeb.OrgstructLive.SourceMembers do
  use Surface.LiveComponent

  #alias Phoenix.LiveView.JS

  alias Qukath.Employees
  alias Qukath.Orgstructs
  alias QukathWeb.EmployeeLive.EmployeeIndexEmployees
  alias Surface.Components.{Link} # ,LiveRedirect}
  #alias QukathWeb.OrgstructLive.NestedOrgstruct

  #alias QukathWeb.Router.Helpers, as: Routes

  #import QukathWeb.ExtraHelper, only: [hide_deleted: 2]
  #alias SurfaceBulma.Button
  @page_size 3

  prop orgstruct, :any, default: nil 
  prop tgt_orgstruct, :any, default: nil 
  prop func, :fun, default: nil 
  data page, :any, default: %Scrivener.Page{total_pages: 0}



  def render(assigns) do
    assigns = if Map.has_key?(assigns, :page), do: assigns, # not sure why page
    else: Map.put(assigns, :page, %Scrivener.Page{total_pages: 0})        
    # page doesn't exist in assigns

    ~F"""
    <div>
      {#for n <- 1..@page.total_pages}
        <Link label={n} to="#" click="member_page" values={page: n} />
      {/for}

      <EmployeeIndexEmployees 
        employees={@page.entries} 
        update_mode="replace"
        update_id="source_member"
        :let={employee: employee, item_id: _item_id}>

        <Link label={employee.name} to="#" click="orgstruct_employee"
        values={employee_id: employee.id, action: :add} />

      </EmployeeIndexEmployees>

      </div>
    """
         #JS.hide(to: "#" <> item_id) |> JS.show(to: "#" <> "target_member-" <> item_id) |> 
    
  end

  #####################
  @impl true
  def mount(socket) do
    #Orgstructs.subscribe("orgstruct_members")

    {:ok, socket
   # |> assign(:page, %Scrivener.Page{})
    }
  end

  def update(assigns, socket) do
    socket = %{socket | assigns: Map.merge(socket.assigns, assigns)}

    IO.puts "in update source_member"
    #IO.inspect assigns
    #IO.inspect socket

    page = emp_o_mem_page(
      socket.assigns.orgstruct.type,
      socket.assigns.orgstruct,
      socket, %{})
    {:ok, socket
    |> assign(:page, page)
    }
  end

  #####################
  @impl true
  def handle_event("member_page", params, socket) do
    #IO.puts "in member_page"
    orgstruct = socket.assigns.orgstruct
    page = emp_o_mem_page(orgstruct.type, orgstruct, socket, params)
    #IO.inspect page
    {:noreply, socket |> assign(page: page) }
  end

  @impl true
  def handle_event("orgstruct_employee", params, socket) do
    Orgstructs.insert_orgstruct_member(
      socket.assigns.tgt_orgstruct.id, 
      params["employee-id"])

    if socket.assigns.func do
      (socket.assigns.func).(socket, params)
    end

    {:noreply, socket }
  end


  #####################
  defp emp_o_mem_page(:corporate_group, orgstruct, socket, params) do
    emp_o_mem_page(:company, orgstruct, socket, params) 
  end

  defp emp_o_mem_page(:company, orgstruct, socket, params) do
    Employees.list_employee_members(%{
      "orgstruct_id" => orgstruct.id,
      "except_orgstruct_id" => socket.assigns.tgt_orgstruct.id,
      "page" => params["page"] || 1,
      "page_size" => @page_size,
    })
  end

  defp emp_o_mem_page(_, orgstruct, socket, params) do
    Employees.list_employee_members(%{
      "orgstruct_id" => orgstruct.id,
      "except_orgstruct_id" => socket.assigns.tgt_orgstruct.id,
      "page" => params["page"] || 1,
      "page_size" => @page_size,
    })
  end

end
