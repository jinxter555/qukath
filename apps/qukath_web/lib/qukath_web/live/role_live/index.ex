defmodule QukathWeb.RoleLive.Index do
  use Surface.LiveView, layout: {QukathWeb.LayoutView, "live.html"}

  alias Qukath.Roles
  alias Qukath.Orgstructs
  alias QukathWeb.RoleLive.RoleFormBulma
  alias Surface.Components.{Link,LiveRedirect}
  alias QukathWeb.Router.Helpers, as: Routes

  import QukathWeb.ExtraHelper, only: [hide_deleted: 2]

  on_mount QukathWeb.AuthUser

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Roles.subscribe()
    {:ok,
      socket
      |> assign(:orgstruct, nil)
      |> assign(:roles, []),
      temporary_assigns: [roles: []]
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
    |> assign(:roles, Roles.list_roles(params))
    |> assign(:orgstruct, orgstruct)
    |> assign(:page_title, "listing roles for #{orgstruct.name}")
  end

  defp apply_action(socket, :index, _params) do
  socket
    |> assign(:roles, Roles.list_roles())
    |> assign(:page_title, "listing roles")
  end

  @impl true
  def handle_event("role_form", params, socket) do
    IO.puts "role_form"
    IO.inspect params
    RoleFormBulma.apply_action(params["action"], params, socket)
    {:noreply, socket}
  end

    @impl true
  def handle_info({:role_created, role}, socket) do
    IO.puts "handle role created"
    IO.inspect role
    {:noreply, update(socket, :roles, fn roles ->
      [role | roles]
    end)}
  end

  @impl true
  def handle_info({:role_updated, role}, socket) do
    IO.puts "handle_info role_updated"
    {:noreply, update(socket, :roles, fn roles ->
      [role | roles]
    end)}
  end

  @impl true
  def handle_info({:role_deleted, role}, socket) do
    {:noreply, update(socket, :roles, fn roles ->
      [role | roles]
    end)}
  end


  def role_form_cid() do
    "rfb01"
  end


end

