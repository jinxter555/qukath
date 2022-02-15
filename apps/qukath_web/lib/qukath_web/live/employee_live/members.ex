defmodule QukathWeb.EmployeeLive.Members do
  use Surface.LiveView

  alias Phoenix.LiveView.JS

  alias Qukath.Employees
  # alias Qukath.Orgstructs
  alias Qukath.Orgemp
  #alias QukathWeb.EmployeeLive.EmployeeFormBulma
  alias QukathWeb.EmployeeLive.EmployeeIndexEmployees
  alias Surface.Components.{Link }#, LiveRedirect}

  #alias QukathWeb.Router.Helpers, as: Routes

  #import QukathWeb.ExtraHelper, only: [hide_deleted: 2]

  on_mount QukathWeb.AuthUser

  @page_size 10

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Employees.subscribe()
    {:ok,
      socket
     |> assign(:page, nil),
     # |> assign(:employees, []),
      temporary_assigns: [employees: []]
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
      apply_action(socket, socket.assigns.live_action, params)
    }
  end
  
  defp apply_action(socket, :add_members, 
    %{"src_orgstruct_id" => src_orgstruct_id,
      "tgt_orgstruct_id" => tgt_orgstruct_id} = params ) do

    IO.puts "params"
    IO.inspect params

    members_tgt = Employees.list_employee_members(%{"orgstruct_id" =>  tgt_orgstruct_id})
    page = Employees.list_employees(%{
      "orgstruct_id" => src_orgstruct_id,
      "except" => members_tgt |> Enum.map(&(&1.id)),
      "page" => 1,
      "page_size" => @page_size,
    })

    socket
    |> assign(:members_src, page.entries)
    |> assign(:members_tgt, members_tgt)
    |> assign(:src_orgstruct_id, src_orgstruct_id) # these two are for
    |> assign(:tgt_orgstruct_id, tgt_orgstruct_id) # Orgemp actions
    |> assign(:page, page)
    |> assign(:page_title, "listing employees members")
  end


  defp apply_action(socket, :members_to_members, 
    %{"src_orgstruct_id" => src_orgstruct_id,
      "tgt_orgstruct_id" => tgt_orgstruct_id} = _params ) do

    members_tgt = Employees.list_employee_members(%{"orgstruct_id" =>  tgt_orgstruct_id})
    page = Employees.list_employee_members(%{
      "orgstruct_id" => src_orgstruct_id,
      "except" => members_tgt |> Enum.map(&(&1.id)),
      "page" => 1,
      "page_size" => @page_size,
    })

    socket
    |> assign(:members_src, page.entries)
    |> assign(:members_tgt, members_tgt)
    |> assign(:src_orgstruct_id, src_orgstruct_id) # these two are for
    |> assign(:tgt_orgstruct_id, tgt_orgstruct_id) # Orgemp actions
    |> assign(:page, page)
    |> assign(:page_title, "listing members members")
  end



  def handle_event("next_member_src_page", params, socket) do
    members_tgt = Employees.list_employee_members(%{"orgstruct_id" => socket.assigns.tgt_orgstruct_id})
    page = Employees.list_employees(%{
      "orgstruct_id" => socket.assigns.src_orgstruct_id,
      "except" => members_tgt |> Enum.map(&(&1.id)),
      "page" => params["page"],
      "page_size" => @page_size,
    })

    {:noreply, socket 
      |> assign(:members_src, page.entries)
      |> assign(:page, page)}

  end

  @impl true
  def handle_event("orgstruct_employee", params, socket) do
    {members_src, members_tgt} = members_action(params["action"], socket, params["employee_id"])
    Orgemp.employee_orgstruct_action(params["action"], params, socket)

    {:noreply, 
      socket
      |>assign(:members_src, members_src)
      |>assign(:members_tgt, members_tgt)
    }
  end

  defp members_action("add", socket, employee_id) do
    members_src = socket.assigns.members_src
    members_tgt = socket.assigns.members_tgt

    added_member = Enum.find(members_src, fn m ->
      m.id == employee_id
    end)

    {Enum.filter(members_src, fn m ->
      m.id != employee_id
    end),
    List.flatten([members_tgt , added_member]) }
  end

  defp members_action("remove", socket, employee_id) do
    members_src = socket.assigns.members_src
    members_tgt = socket.assigns.members_tgt

    removed_member = Enum.find(members_tgt, fn m ->
      m.id == employee_id
    end)

    {List.flatten([members_src , removed_member]),
    Enum.filter(members_tgt, fn m ->
      m.id != employee_id
    end)}

  end
  
  

end
