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
    members_src = Employees.list_employees(orgstruct_id: src_orgstruct_id)
    members_tgt = Employees.list_employee_members(orgstruct_id:  tgt_orgstruct_id)

    socket
    |> assign(:members_src, members_src)
    |> assign(:members_tgt, members_tgt)
    |> assign(:src_orgstruct_id, src_orgstruct_id)
    |> assign(:tgt_orgstruct_id, tgt_orgstruct_id)
    |> assign(:page_title, "listing employees members")
  end

  @impl true
  def handle_event("orgstruct_employee", params, socket) do
    IO.puts "params"
    IO.inspect params
    Orgemp.employee_orgstruct_action(params["action"], params, socket)
    {:noreply, socket}
  end
  

end
