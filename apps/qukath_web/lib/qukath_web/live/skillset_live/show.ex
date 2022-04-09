defmodule QukathWeb.SkillsetLive.Show do

  use Surface.LiveView, layout: {QukathWeb.LayoutView, "live.html"}

  alias Surface.Components.{Link , LiveRedirect}
  alias QukathWeb.Router.Helpers, as: Routes


  alias Qukath.{Skillsets,Roles}
  alias QukathWeb.SkillsetLive.SkillsetFormBulma

  alias Surface.Components.{Link,LiveRedirect}
  alias QukathWeb.Router.Helpers, as: Routes

  import QukathWeb.ExtraHelper, only: [hide_deleted: 2]

  import QukathWeb.SkillsetLive.Index, only: [skillset_form_cid: 0]


  on_mount QukathWeb.AuthUser


  @impl true
  def render(assigns) do
    ~F"""
     <SkillsetFormBulma id={skillset_form_cid()} />
     skillset for role: {@role.name}: <br>
    <Link label={@skillset.name} to="#" click="skillset_form" values={skillset_id: @skillset.id, action: :edit, cid: skillset_form_cid()} />
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    # if connected?(socket), do: Orgstructs.subscribe()
    {:ok, socket }
  end


  @impl true
  def handle_params(%{"id" => id} = _params, _url, socket) do
    skillset = Skillsets.get_skillset!(id)
    role = Roles.get_role!(skillset.role_id)
    {:noreply,
     socket
     |> assign(:skillset, skillset)
     |> assign(:role, role)
     |> assign(:page_title, page_title(socket.assigns.live_action))
    }
  end

  @impl true
  def handle_event("skillset_form", params, socket) do
     SkillsetFormBulma.apply_action(params["action"], params, socket)
    {:noreply, socket}
  end


  defp page_title(:show), do: "Show skillset"
  defp page_title(:edit), do: "Edit skillset"


end
