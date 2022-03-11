defmodule QukathWeb.TodoLive.Show do
  use Surface.LiveView

  alias Qukath.Work
  #alias Qukath.Orgstructs
  alias QukathWeb.TodoLive.TodoFormBulma
  alias Surface.Components.Link
  alias SurfaceBulma.Dropdown
  import QukathWeb.TodoLive.Index, only: [todo_form_cid: 0]
  alias Qukath.EmployeeRoles
  alias QukathWeb.RoleLive.SelectEmployeeRoles

  #import QukathWeb.ExtraHelper, only: [hide_deleted: 2]

  on_mount QukathWeb.AuthUser

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Work.subscribe()
    {:ok, socket
     |> assign(:show_dropdown, false)
     |> assign(:employee_roles, [])
    }
  end

  @impl true
  def handle_params(%{"id" => id} = _params, _url, socket) do
    todo = Work.get_todo!(id)
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:todo, todo)
     |> assign(:employee_roles, EmployeeRoles.list_employee_roles(orgstruct_id: todo.orgstruct_id))
    }
  end

  @impl true
  def handle_event("todo_form", params, socket) do
    IO.puts "todo_form"
    IO.inspect params
    TodoFormBulma.apply_action(params["action"], params, socket)
    {:noreply, socket}
  end

  @impl true
  def handle_event("todo_state", params, socket) do
    send_update(SurfaceBulma.Dropdown, id: "statedd01", active: false, open: false)
    todo = Work.get_todo!(params["todo-id"])
    {:ok, _ts} = Work.create_todo_state(todo, params) 
    todo = Work.get_todo!(params["todo-id"])

    {:noreply, 
      socket 
      |> assign(todo: todo) 
      #|> assign(show_dropdown: false) 
    }
  end

  @impl true
  def handle_event("assign_owner", params, socket) do
    IO.puts "assign_owner"
    SelectEmployeeRoles.apply_action(params["action"], params, socket)
    {:noreply, socket}
  end
 
  @impl true
  def handle_event("assign_owner2", params, socket) do
    IO.puts "assign_owner2"
    SelectEmployeeRoles.apply_action2(params["action"], params, socket)
    {:noreply, socket}
  end


    @impl true
  def handle_info({:todo_created, todo}, socket) do
    {:noreply, update(socket, :todos, fn todos ->
      [todo | todos]
    end)}
  end

  @impl true
  def handle_info({:todo_updated, {todo, todo_info}}, socket) do
    {:noreply,
      assign(socket, :todo, Work.merge(todo, todo_info))}
  end

  @impl true
  def handle_info({:todo_deleted, todo}, socket) do
    {:noreply, update(socket, :todos, fn todos ->
      [todo | todos]
    end)}
  end

  defp page_title(:show), do: "Show todo"
  defp page_title(:edit), do: "Edit todo"

  defp states() do
    Ecto.Enum.mappings(Qukath.Work.TodoState, :state)
  end

  #defp active_state(state1, state2) do
  #  if state1 == state2, do: " is-active",
  #  else: ""
  #end

  defp active_state(state1, state2) when state1 == state2, do: " is-active"
  defp active_state(_, _),  do: " "
end

