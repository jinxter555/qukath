defmodule QukathWeb.EmployeeLive.EmployeeIndex do
  use Surface.LiveView

  alias Qukath.Employees
  alias QukathWeb.EmployeeLive.EmployeeFormBulma
  alias Surface.Components.Link

  alias QukathWeb.EmployeeLive.EmployeeIndexEmployees

  on_mount QukathWeb.AuthUser

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Employees.subscribe()
    {:ok,
      socket
      |> assign(:employees, list_employees()),
      temporary_assigns: [employees: []]
    }
  end
  
  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
      apply_action(socket, socket.assigns.live_action, params)
    }
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "listing employees")
  end

  defp apply_action(socket, :list, params) do
    socket
    |> assign(:employees, Employees.list_employees(params))
    |> assign(:orgstruct_id, params["orgstruct_id"])
    |> assign(:page_title, "listing employees by orgstruct")
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

  defp list_employees do
    Employees.list_employees()
  end

end
