defmodule QukathWeb.SkillsetLive.Skills do
  use Surface.LiveView, layout: {QukathWeb.LayoutView, "live.html"}

  alias Qukath.Skillsets
  alias Qukath.Roles
  alias QukathWeb.SkillsetLive.SkillsetFormBulma
  alias Surface.Components.{Link,LiveRedirect}
  alias QukathWeb.Router.Helpers, as: Routes

  import QukathWeb.ExtraHelper, only: [hide_deleted: 2]

  on_mount QukathWeb.AuthUser

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Skillsets.subscribe()
    {:ok,
      socket
      |> assign(:role, nil)
      |> assign(:skillsets, []),
      temporary_assigns: [skillsets: []]
    }
  end
  
  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
      apply_action(socket, socket.assigns.live_action, params)
    }
  end

  defp apply_action(socket, :index, %{"role_id" => role_id} = params) do
    role = Roles.get_role!(role_id)
    socket
    |> assign(:skillsets, Skillsets.list_skillsets(params))
    |> assign(:role, role)
    |> assign(:page_title, "listing skillsets for #{role.name}")
  end

  defp apply_action(socket, :index, _params) do
  socket
    |> assign(:skillsets, Skillsets.list_skillsets())
    |> assign(:page_title, "listing skillsets")
  end

  @impl true
  def handle_event("skillset_form", params, socket) do
    SkillsetFormBulma.apply_action(params["action"], params, socket)
    {:noreply, socket}
  end

    @impl true
  def handle_info({:skillset_created, skillset}, socket) do
    {:noreply, update(socket, :skillsets, fn skillsets ->
      [skillset | skillsets]
    end)}
  end

  @impl true
  def handle_info({:skillset_updated, skillset}, socket) do
    IO.puts "handle_info role_updated"
    {:noreply, update(socket, :skillsets, fn skillsets ->
      [skillset | skillsets]
    end)}
  end

  @impl true
  def handle_info({:skillset_deleted, skillset}, socket) do
    {:noreply, update(socket, :skillsets, fn skillsets ->
      [skillset | skillsets]
    end)}
  end


  def skillset_form_cid() do
    "sksfb01"
  end

end

