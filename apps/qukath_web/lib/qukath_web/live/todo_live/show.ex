defmodule QukathWeb.TodoLive.Show do
  use Surface.LiveView

  alias Qukath.Work
  alias Qukath.Orgstructs
  alias QukathWeb.TodoLive.TodoFormBulma
  alias Surface.Components.Link
  import QukathWeb.TodoLive.Index, only: [todo_form_cid: 0]

  #import QukathWeb.ExtraHelper, only: [hide_deleted: 2]

  on_mount QukathWeb.AuthUser

  @impl true
  def mount(_params, _session, socket) do
    #if connected?(socket), do: Work.subscribe()
    {:ok, socket }
  end

  @impl true
  def handle_params(%{"id" => id} = _params, _url, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:todo, Work.get_todo!(id))
    }
  end

  @impl true
  def handle_event("todo_form", params, socket) do
    IO.puts "todo_form"
    IO.inspect params
    TodoFormBulma.apply_action(params["action"], params, socket)
    {:noreply, socket}
  end


  defp page_title(:show), do: "Show todo"
  defp page_title(:edit), do: "Edit todo"

end
