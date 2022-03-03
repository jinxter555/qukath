defmodule QukathWeb.RoleLive.Show do

  use Surface.LiveView, layout: {QukathWeb.LayoutView, "live.html"}

  alias Surface.Components.{Link , LiveRedirect}
  alias QukathWeb.Router.Helpers, as: Routes


  alias Qukath.Roles
  alias QukathWeb.RoleLive.RoleFormBulma

  alias Surface.Components.{Link,LiveRedirect}
  alias QukathWeb.Router.Helpers, as: Routes

  import QukathWeb.ExtraHelper, only: [hide_deleted: 2]

  import QukathWeb.RoleLive.Index, only: [role_form_cid: 0]


  on_mount QukathWeb.AuthUser


  @impl true
  def render(assigns) do
    ~F"""
     <RoleFormBulma id={role_form_cid()} />
      role: <Link label={@role.name} to="#" click="role_form" values={role_id: @role.id, action: :edit, cid: role_form_cid()} />
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    # if connected?(socket), do: Orgstructs.subscribe()
    {:ok, socket }
  end


  @impl true
  def handle_params(%{"id" => id} = _params, _url, socket) do
    role = Roles.get_role!(id)
    {:noreply,
     socket
     |> assign(:role, role)
     |> assign(:page_title, page_title(socket.assigns.live_action))
    }
  end

  @impl true
  def handle_event("role_form", params, socket) do
     RoleFormBulma.apply_action(params["action"], params, socket)
    {:noreply, socket}
  end


  defp page_title(:show), do: "Show role"
  defp page_title(:edit), do: "Edit role"


end
