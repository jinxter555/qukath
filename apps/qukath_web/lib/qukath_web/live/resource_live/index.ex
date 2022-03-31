defmodule QukathWeb.ResourceLive.Index do
  use Surface.LiveView, layout: {QukathWeb.LayoutView, "live.html"}

  alias Qukath.Resources
  alias Qukath.Orgstructs
  alias QukathWeb.ResourceLive.ResourceFormBulma
  alias Surface.Components.{Link,LiveRedirect}
  alias QukathWeb.Router.Helpers, as: Routes

  import QukathWeb.ExtraHelper, only: [hide_deleted: 2]

  on_mount QukathWeb.AuthUser

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Resources.subscribe()
    {:ok,
      socket
      |> assign(:orgstruct, nil)
      |> assign(:resources, []),
      temporary_assigns: [resources: []]
    }
  end
  
  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
      apply_action(socket, socket.assigns.live_action, params)
    }
  end


  defp apply_action(socket, :orgstruct, params), do:
    apply_action(socket, :index, params) 

  defp apply_action(socket, :index, %{"orgstruct_id" => orgstruct_id} = params) do
    orgstruct = Orgstructs.get_orgstruct!(orgstruct_id)
    socket
    |> assign(:resources, Resources.list_resources(params)) #
    |> assign(:orgstruct, orgstruct)
    |> assign(:page_title, "listing resources for #{orgstruct.name}")
  end

  defp apply_action(socket, :index, _params) do
  socket
    |> assign(:resources, Resources.list_resources())
    |> assign(:page_title, "listing resources")
  end

  @impl true
  def handle_event("resource_form", params, socket) do
    IO.puts "resource_form"
    IO.inspect params
    ResourceFormBulma.apply_action(params["action"], params, socket)
    {:noreply, socket}
  end

    @impl true
  def handle_info({:resource_created, resource}, socket) do
    IO.puts "handle resource created"
    IO.inspect resource
    {:noreply, update(socket, :resources, fn resources ->
      [resource | resources]
    end)}
  end

  @impl true
  def handle_info({:resource_updated, resource}, socket) do
    IO.puts "handle_info resource_updated"
    {:noreply, update(socket, :resources, fn resources ->
      [resource | resources]
    end)}
  end

  @impl true
  def handle_info({:resource_deleted, resource}, socket) do
    {:noreply, update(socket, :resources, fn resources ->
      [resource | resources]
    end)}
  end


  def permit_form_cid() do
    "pfb01"
  end

  def resource_form_cid() do
    "rscfb01"
  end



end

