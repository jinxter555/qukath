defmodule QukathWeb.OrgstructLive.Show do

  use Surface.LiveView

  #import QukathWeb.ExtraHelper, only: [hide_deleted: 2]
  alias Surface.Components.{Link , LiveRedirect}
  alias QukathWeb.Router.Helpers, as: Routes

  import QukathWeb.OrgstructLive.Index, only: [orgstruct_form_cid: 0]


  alias Qukath.Orgstructs
  alias QukathWeb.OrgstructLive.OrgstructFormBulma
  alias QukathWeb.OrgstructLive.MembersMembers

  alias QukathWeb.OrgstructLive.NestedOrgstruct

  on_mount QukathWeb.AuthUser

  @impl true
  def mount(_params, _session, socket) do
    # if connected?(socket), do: Orgstructs.subscribe()
    {:ok, socket }
  end


  @impl true
  def handle_params(%{"id" => id} = _params, _url, socket) do
     orgstruct = Orgstructs.get_orgstruct!(id)
     nested_orgstruct = Orgstructs.build_nested_orgstruct(orgstruct.id)
     listed_orgstruct = Orgstructs.list_descendants(orgstruct.id)
    {:noreply,
     socket
     |> assign(:orgstruct, orgstruct)
     |> assign(:nested_orgstruct, nested_orgstruct)
     |> assign(:listed_orgstruct, listed_orgstruct)
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


  def mydisplay(assigns) do
    ~F"""
    {@orgstruct.name} : 
    {@orgstruct.type} <br>
    """
  end
  defp rambo(socket, params) do
    IO.puts "hello from rambo"
    IO.inspect socket
    IO.inspect params
  end

end
