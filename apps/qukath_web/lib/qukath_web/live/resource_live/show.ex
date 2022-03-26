defmodule QukathWeb.ResourceLive.Show do

  use Surface.LiveView, layout: {QukathWeb.LayoutView, "live.html"}

  alias Surface.Components.{Link , LiveRedirect}
  alias QukathWeb.Router.Helpers, as: Routes


  alias Qukath.Resources
  alias QukathWeb.ResourceLive.ResourceFormBulma

  #alias Surface.Components.{Link,LiveRedirect}
  #alias QukathWeb.Router.Helpers, as: Routes

  #import QukathWeb.ExtraHelper, only: [hide_deleted: 2]

  import QukathWeb.ResourceLive.Index, only: [resource_form_cid: 0]


  on_mount QukathWeb.AuthUser


  @impl true
  def render(assigns) do
    ~F"""
      <ResourceFormBulma id={resource_form_cid()} /> resource: 
      <Link label={@resource.name} to="#" click="resource_form"
        values={resource_id: @resource.id, action: :edit, cid: resource_form_cid()} />
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    # if connected?(socket), do: Orgstructs.subscribe()
    {:ok, socket }
  end

  @impl true
  def handle_params(%{"id" => id} = _params, _url, socket) do
    resource = Resources.get_resource!(id)
    {:noreply,
     socket
     |> assign(:resource, resource)
     |> assign(:page_title, page_title(socket.assigns.live_action))
    }
  end

  @impl true
  def handle_event("resource_form", params, socket) do
     ResourceFormBulma.apply_action(params["action"], params, socket)
    {:noreply, socket}
  end

  defp page_title(:show), do: "Show resource"
  defp page_title(:edit), do: "Edit resource"

end
