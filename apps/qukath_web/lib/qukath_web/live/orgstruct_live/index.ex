defmodule QukathWeb.OrgstructLive.Index do

  use Surface.LiveView

  import QukathWeb.ExtraHelper, only: [hide_deleted: 2]

  alias Qukath.Orgstructs
  alias QukathWeb.OrgstructLive.OrgstructFormBulma
  alias Surface.Components.{Link, LiveRedirect}

  alias QukathWeb.Router.Helpers, as: Routes


  #alias QukathWeb.OrgstructLive.OrgstructIndexOrgstructs
  

  on_mount QukathWeb.AuthUser

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Orgstructs.subscribe()
    {:ok,
      socket
      |> assign(:orgstructs, []),
      temporary_assigns: [orgstructs: []]
    }
  end


  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing all")
    |> assign(:orgstructs, Orgstructs.list_orgstructs())
  end

  defp apply_action(socket, :index_type, params) do
    socket
    |> assign(:page_title, "Listing types")
    |> assign(:orgstructs, Orgstructs.list_orgstructs(params["type"]))
  end


  @impl true
  def handle_event("orgstruct_form", params, socket) do
    OrgstructFormBulma.apply_action(params["action"], params, socket)
    {:noreply, socket}
  end


    @impl true
  def handle_info({:orgstruct_created, orgstruct}, socket) do
    {:noreply, update(socket, :orgstructs, fn orgstructs ->
      [orgstruct | orgstructs]
    end)}
  end

  @impl true
  def handle_info({:orgstruct_updated, orgstruct}, socket) do
    {:noreply, update(socket, :orgstructs, fn orgstructs ->
       [orgstruct | orgstructs]
    end)}
  end

  @impl true
  def handle_info({:orgstruct_deleted, orgstruct}, socket) do
    {:noreply, update(socket, :orgstructs, fn orgstructs ->
       [orgstruct | orgstructs]
    end)}
  end



  def orgstruct_form_cid() do
    "ofb01"
  end

end
