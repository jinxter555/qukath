defmodule QukathWeb.EmployeeLive.Show do
  use Surface.LiveView

  alias Qukath.Employees
  #alias Qukath.Orgstructs
  #alias QukathWeb.EmployeeLive.EmployeeFormBulma
  alias Surface.Components.{LiveRedirect}
   alias QukathWeb.Router.Helpers, as: Routes


  #import QukathWeb.ExtraHelper, only: [hide_deleted: 2]

  on_mount QukathWeb.AuthUser

  def render(assigns) do
    ~F"""
    {@employee.name}: <LiveRedirect label="Roles" to={Routes.employee_roles_index_roles_path(@socket, :index, @employee)}/>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    #if connected?(socket), do: Employees.subscribe()
    {:ok, socket }
  end

  @impl true
  def handle_params(%{"id" => id} = _params, _url, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:employee, Employees.get_employee!(id))

    }
  end

  defp page_title(:show), do: "Show employee"
  defp page_title(:edit), do: "Edit employee"

end
