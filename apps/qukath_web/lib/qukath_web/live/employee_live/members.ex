defmodule QukathWeb.EmployeeLive.Members do
  use Surface.LiveView

  alias Phoenix.LiveView.JS

  alias Qukath.Employees
  # alias Qukath.Orgstructs
  alias Qukath.Orgemp
  alias QukathWeb.EmployeeLive.EmployeeFormBulma
  alias QukathWeb.EmployeeLive.EmployeeIndexEmployees
  alias Surface.Components.{Link, LiveRedirect}

  alias QukathWeb.Router.Helpers, as: Routes

  import QukathWeb.ExtraHelper, only: [hide_deleted: 2]

  on_mount QukathWeb.AuthUser

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Employees.subscribe()
    {:ok,
      socket
      |> assign(:orgstruct, nil)
      |> assign(:employees, []),
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
      "tgt_orgstruct_id" => tgt_orgstruct_id} = _params ) do
    members_tgt = Employees.list_employee_members(orgstruct_id:  tgt_orgstruct_id)
    members_src = Employees.list_employees(
      orgstruct_id: src_orgstruct_id,
      except: members_tgt |>   Enum.map(&(&1.id))
    )

    # need filter

    socket
    |> assign(:members_src, members_src)
    |> assign(:members_tgt, members_tgt)
    |> assign(:src_orgstruct_id, src_orgstruct_id)
    |> assign(:tgt_orgstruct_id, tgt_orgstruct_id)
    |> assign(:page_title, "listing employees members")
  end

  @impl true
  def handle_event("orgstruct_employee", params, socket) do
    
    {members_src, members_tgt} = members_action(params["action"], socket, params["employee_id"])
    Orgemp.employee_orgstruct_action(params["action"], params, socket)

    #IO.puts "members_src"
    #IO.inspect Enum.map( members_src, fn x -> x.id end)
    #IO.puts "members_tgt"
    #IO.inspect Enum.map( members_tgt, fn x -> x.id end)

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
