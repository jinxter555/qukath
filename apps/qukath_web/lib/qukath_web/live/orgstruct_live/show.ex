defmodule QukathWeb.OrgstructLive.Show do

  use Surface.LiveView, layout: {QukathWeb.LayoutView, "live.html"}

  alias Surface.Components.{Link , LiveRedirect}
  alias QukathWeb.Router.Helpers, as: Routes

  import QukathWeb.OrgstructLive.Index, only: [orgstruct_form_cid: 0]


  alias Qukath.Orgstructs
  alias QukathWeb.OrgstructLive.OrgstructFormBulma

  on_mount QukathWeb.AuthUser

  @impl true
  def mount(_params, _session, socket) do
    # if connected?(socket), do: Orgstructs.subscribe()
    {:ok, socket }
  end


  @impl true
  def handle_params(%{"id" => id} = _params, _url, socket) do
     orgstruct = Orgstructs.get_orgstruct!(id)
     orgstruct_list = Orgstructs.list_descendants(orgstruct.id)
    {:noreply,
     socket
     #|> put_flash(:info, "hello who r u?: #{orgstruct.name}")
     #|> put_flash(:error, "what is going on: #{orgstruct.name}")
     |> assign(:orgstruct, orgstruct)
     |> assign(:orgstruct_list, orgstruct_list)
     |> assign(:page_title, page_title(socket.assigns.live_action))
    }
  end

  @impl true
  def handle_event("orgstruct_form", params, socket) do
    OrgstructFormBulma.apply_action(params["action"], params, socket)
    {:noreply, socket}
  end

  defp newlinks(assigns) do
    ~F"""
    {#case @orgstruct.type} 
      {#match :corporate_group}
      <Link label="New Company" to="#" click="orgstruct_form" values={
      action: :new,
      orgstruct_id: @orgstruct.id,
      type: :company,
      cid: orgstruct_form_cid()} class="button"/><br>

      {#match :company}
      <Link label="New Department" to="#" click="orgstruct_form" values={
      action: :new,
      orgstruct_id: @orgstruct.id,
      type: :department,
      cid: orgstruct_form_cid()} class="button"/>

      <Link label="New Team" to="#" click="orgstruct_form" values={
      action: :new,
      orgstruct_id: @orgstruct.id,
      type: :team,
      cid: orgstruct_form_cid()} class="button"/><br>

      {#match :department}
      <Link label="New Team" to="#" click="orgstruct_form" values={
      action: :new,
      orgstruct_id: @orgstruct.id,
      type: :team,
      cid: orgstruct_form_cid()} class="button"/><br>

      {#match _}
    {/case}
    """
  end

  defp page_title(:show), do: "Show orgstruct"
  defp page_title(:edit), do: "Edit orgstruct"


end
