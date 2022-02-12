defmodule QukathWeb.TodoLive.TodoIndex do
  use Surface.LiveView

  alias Qukath.Work
  #alias Qukath.Work.Todo
  #alias Qukath.Employees
  alias QukathWeb.TodoLive.TodoFormBulma
  alias Surface.Components.Link
  alias QukathWeb.TodoLive.TodoIndexTodos


  on_mount QukathWeb.AuthUser

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Work.subscribe()
    {:ok,
      socket
      |> assign(:orgstruct_id, nil)
      |> assign(:todos, list_todos()),
      temporary_assigns: [todos: []]
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
    |> assign(:page_title, "listing todos")
  end

  defp apply_action(socket, :list, params) do
    socket
    |> assign(:todos, Work.list_todos(params))
    |> assign(:orgstruct_id, params["orgstruct_id"])
    |> assign(:page_title, "listing todos by orgstruct")
  end

  @impl true
  def handle_event("todo_form", params, socket) do
    IO.puts "todo_form"
    IO.inspect params
    TodoFormBulma.apply_action(params["action"], params, socket)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:todo_created, todo}, socket) do
    {:noreply, update(socket, :todos, fn todos ->
      [todo | todos]
    end)}
  end

  @impl true
  def handle_info({:todo_updated, todo}, socket) do
    {:noreply, update(socket, :todos, fn todos ->
      [todo | todos]
    end)}
  end

  @impl true
  def handle_info({:todo_deleted, todo}, socket) do
    {:noreply, update(socket, :todos, fn todos ->
      [todo | todos]
    end)}
  end

  # todo component id
  def todo_form_cid() do
    "tfb01"
  end

  defp list_todos do
    Work.list_todos()
  end

end
