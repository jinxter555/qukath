defmodule QukathWeb.EmptdLive.Index do
  use Surface.LiveView

  alias Qukath.Employees
  #alias Qukath.Orgstructs
  #alias QukathWeb.EmployeeLive.EmployeeFormBulma
  alias QukathWeb.TodoLive.TodoFormBulma

  alias Surface.Components.Link

  #import QukathWeb.ExtraHelper, only: [hide_deleted: 2]
  #
  import  QukathWeb.TodoLive.Index, only: [todo_form_cid: 0]

  on_mount QukathWeb.AuthUser

  @impl true
  def mount(_params, _session, socket) do
    #if connected?(socket), do: Employees.subscribe()
    {:ok, socket }
  end

  @impl true
  def handle_params(%{"employee_id" => id} = _params, _url, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:employee, Employees.get_employee!(id))

    }
  end


  @impl true
  def handle_event("todo_form", params, socket) do
    IO.puts "todo_form from emptds"
    IO.inspect params
    TodoFormBulma.apply_action(params["action"], params, socket)
    {:noreply, socket}
  end


  defp page_title(:index), do: "index todos"
  defp page_title(:show), do: "Show employee"
  defp page_title(:edit), do: "Edit employee"

end
