defmodule QukathWeb.EmployeeLive.Index do
  use Surface.LiveView

  alias Qukath.Employees
  alias Qukath.Orgstructs
  alias QukathWeb.EmployeeLive.EmployeeFormBulma
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
  
  defp apply_action(socket, :index, %{"orgstruct_id" => orgstruct_id} = params) do
    orgstruct = Orgstructs.get_orgstruct!(orgstruct_id)
    socket
    |> assign(:employees, Employees.list_employees(params))
    |> assign(:orgstruct, orgstruct)
    |> assign(:page_title, "listing employees for #{orgstruct.name}")
  end

  defp apply_action(socket, :orgstruct, params), do:
    apply_action(socket, :index, params) 

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:employees, Employees.list_employees())
    |> assign(:page_title, "listing all employees")
  end

  @impl true
  def handle_event("employee_form", params, socket) do
    IO.puts "employee_form"
    IO.inspect params
    EmployeeFormBulma.apply_action(params["action"], params, socket)
    {:noreply, socket}
  end

  
  @impl true
  def handle_info({:employee_created, employee}, socket) do
    {:noreply, update(socket, :employees, fn employees ->
      [employee | employees]
    end)}
  end

  @impl true
  def handle_info({:employee_updated, employee}, socket) do
    {:noreply, update(socket, :employees, fn employees ->
      [employee | employees]
    end)}
  end

  @impl true
  def handle_info({:employee_deleted, employee}, socket) do
    {:noreply, update(socket, :employees, fn employees ->
      [employee | employees]
    end)}
  end

  def employee_form_cid() do
    "mfb01"
  end

  defp comp_group(nil), do: false
  defp comp_group(orgstruct) do
    orgstruct.type == :company or orgstruct.type == :corporate_group
  end

end
