defmodule QukathWeb.OrgstructLive.MembersMembers do

  use Surface.LiveView, layout: {QukathWeb.LayoutView, "live.html"}

  #import QukathWeb.ExtraHelper, only: [hide_deleted: 2]
  alias Surface.Components.{Link }#, LiveRedirect}
  #alias QukathWeb.Router.Helpers, as: Routes



  alias Qukath.Orgstructs
  # alias Qukath.Organizations.Orgstruct
  alias QukathWeb.OrgstructLive.SourceMembers
  alias QukathWeb.OrgstructLive.TargetMembers

  alias QukathWeb.OrgstructLive.NestedOrgstruct

  on_mount QukathWeb.AuthUser

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Orgstructs.subscribe("orgstruct_members")
    {:ok, socket 
    }
  end

  @impl true
  def handle_params(%{"orgstruct_id" => orgstruct_id} = _params, _url, socket) do
     orgstruct = Orgstructs.get_orgstruct!(orgstruct_id)
     src_nested_orgstruct = Orgstructs.build_nested_orgstruct(orgstruct.id)
    {:noreply,
     socket
     |> assign(:orgstruct, orgstruct)
     |> assign(:src_orgstruct, orgstruct)
     |> assign(:tgt_orgstruct, nil)
     |> assign(:src_nested_orgstruct, src_nested_orgstruct)
     |> assign(:tgt_nested_orgstruct, src_nested_orgstruct)
     |> assign(:page_title, page_title(socket.assigns.live_action))
    }
  end
  
  @impl true
  def handle_event("src_orgstruct", params, socket) do
    src_orgstruct = Orgstructs.get_orgstruct!(params["orgstruct-id"])
    {:noreply, socket
    |> assign(src_orgstruct: src_orgstruct)
    }
  end

  @impl true
  def handle_event("tgt_orgstruct", params, socket) do
    tgt_orgstruct = Orgstructs.get_orgstruct!(params["orgstruct-id"])
    {:noreply, socket
    |> assign(tgt_orgstruct: tgt_orgstruct)
    }
  end

  @impl true
  def handle_info({:orgstruct_member_inserted, em}, socket) do
    #IO.puts "orgstruct_member_inserted"
    #IO.inspect em
    send_update SourceMembers, id: "sm01", em: em
    send_update TargetMembers, id: "tm01", em: em

    {:noreply, socket}
  end
  
  @impl true                                                                                                                                                                                                
  def handle_info({:orgstruct_member_deleted, em}, socket) do                                                                                                                                        
    # IO.puts "orgstruct_member_deleted"
    # IO.inspect em
    send_update SourceMembers, id: "sm01", em: em
    send_update TargetMembers, id: "tm02", em: em
     {:noreply, socket }                                                                                                                                                                                     
  end                                                                                                                                                                                                       

  defp page_title(:members), do: "member action in orgstruct"

  defp rambo(_socket, _params) do
   # IO.puts "hello from rambo"
   # IO.inspect socket
   # IO.inspect params
  end
  
  def src_func(assigns) do
    ~F"""
    <Link label={@orgstruct.name} to="#" click="src_orgstruct"
      values={ orgstruct_id: @orgstruct.id}
      class={@orgstruct.id == @selected_orgstruct.id && "has-text-primary"}/> <br/>
    """
  end

  def tgt_func(assigns) do
    ~F"""
    {#if @selected_orgstruct}
      <Link label={@orgstruct.name} to="#" click="tgt_orgstruct" values={orgstruct_id: @orgstruct.id}
        class={@orgstruct.id == @selected_orgstruct.id && "has-text-primary-light"}/> <br/>
    {#else}
      <Link label={@orgstruct.name} to="#" click="tgt_orgstruct" values={orgstruct_id: @orgstruct.id}/><br/>
    {/if}
    """
  end

end
