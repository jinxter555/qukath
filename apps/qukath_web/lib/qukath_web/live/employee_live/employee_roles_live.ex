defmodule QukathWeb.EmployeeRolesLive.Index do
  use Surface.LiveView

  alias Qukath.Orgstructs
  alias Qukath.Employees
  alias Qukath.Roles

  def render(assigns) do
    ~F"""
    hello,world
    """
  end

    @impl true
  def handle_params(%{"employee_id" => employee_id} = _params, _url, socket) do
    employee = Employees.get_employee!(employee_id)
    #nested_orgstructs = Orgstructs.list_nested_orgstructs_by_employee(employee)
    roles = Roles.list_roles(orgstruct_id: employee.orgstruct_id)
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:employee, Employees.get_employee!(employee_id))
     |> assign(:roles, roles)
    }
  end
  defp page_title(:index), do: "index employee roles"
  defp page_title(:show), do: "Show employee roles"
  defp page_title(:edit), do: "Edit employee roles"


end
