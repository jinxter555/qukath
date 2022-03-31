defmodule QukathWeb.ResourceLive.Show do

  use Surface.LiveView, layout: {QukathWeb.LayoutView, "live.html"}

  alias Surface.Components.{Link } # , LiveRedirect}
  #alias QukathWeb.Router.Helpers, as: Routes


  alias Qukath.Resources
  alias Qukath.Permits
  alias QukathWeb.ResourceLive.{ResourceFormBulma, PermitFormBulma}

  #alias Surface.Components.{Link,LiveRedirect}
  #alias QukathWeb.Router.Helpers, as: Routes

  import QukathWeb.ExtraHelper, only: [hide_deleted: 2]

  import QukathWeb.ResourceLive.Index, only: [permit_form_cid: 0, resource_form_cid: 0 ]


  on_mount QukathWeb.AuthUser


  @impl true
  def render(assigns) do
    ~F"""
      <PermitFormBulma id={permit_form_cid()} resource_id={@resource.id}/> 
      <ResourceFormBulma id={resource_form_cid()} /> resource: 
      <Link label={@resource.name} to="#" click="resource_form"
        values={resource_id: @resource.id, action: :edit, cid: resource_form_cid()} />

      <Link label="New Action Verb" to="#" click="permit_form" 
        values={action: :new, cid: permit_form_cid()} class="button"/>


        
      <div id="permits" phx-update="append">
         {#for permit <- @permits }

         <div id={"permit-#{permit.id}"} class={hide_deleted(permit, "container")}>
           {permit.verb}
           <Link label="Edit" to="#" click="permit_form" values={permit_id: permit.id, action: :edit, cid: permit_form_cid()} />
           <Link label="Delete" to="#" click="permit_form" values={permit_id: permit.id, action: :delete} />
         </div>
         {/for}
       </div>
       

    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Permits.subscribe()
    {:ok, socket,
      temporary_assigns: [permits: []]
    }
  end

  @impl true
  def handle_params(%{"id" => id} = _params, _url, socket) do
    resource = Resources.get_resource!(id)
    permits = Permits.list_permits(%{"resource_id" => resource.id})
    {:noreply,
     socket
     |> assign(:resource, resource)
     |> assign(:permits, permits)
     |> assign(:page_title, page_title(socket.assigns.live_action))
    }
  end

  @impl true
  def handle_event("resource_form", params, socket) do
     ResourceFormBulma.apply_action(params["action"], params, socket)
    {:noreply, socket}
  end

  @impl true
  def handle_event("permit_form", params, socket) do
     PermitFormBulma.apply_action(params["action"], params, socket)
    {:noreply, socket}
  end

      @impl true
  def handle_info({:permit_created, permit}, socket) do
    {:noreply, update(socket, :permits, fn permits ->
      [permit | permits]
    end)}
  end

  @impl true
  def handle_info({:permit_updated, permit}, socket) do
    {:noreply, update(socket, :permits, fn permits ->
      [permit | permits]
    end)}
  end

  @impl true
  def handle_info({:permit_deleted, permit}, socket) do
    {:noreply, update(socket, :permits, fn permits ->
      [permit | permits]
    end)}
  end



  defp page_title(:show), do: "Show resource"
  defp page_title(:edit), do: "Edit resource"

end
