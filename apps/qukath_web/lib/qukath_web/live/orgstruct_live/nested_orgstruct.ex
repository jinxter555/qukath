defmodule QukathWeb.OrgstructLive.NestedOrgstruct do
  use Surface.Component

  alias Surface.Components.{LiveRedirect}
  alias QukathWeb.OrgstructLive.NestedOrgstruct 
  alias QukathWeb.Router.Helpers, as: Routes

  prop socket, :any, required: true
  prop nested_orgstruct, :any, required: true
  slot default

  def render(assigns) do
    ~F"""
    {#if @nested_orgstruct }
      {#for child <- @nested_orgstruct.children }
        <.print_orgstruct orgstruct={child} socket={@socket}/>
        {#if Map.has_key?(child, :children) }
          <NestedOrgstruct nested_orgstruct={child} socket={@socket}/>
        {/if}
      {/for}
    {/if}
    """
  end

  defp print_orgstruct(assigns) do
    ~F"""
      <LiveRedirect label={@orgstruct.name} to={Routes.orgstruct_show_path(@socket, :show, @orgstruct)}/> :
          {@orgstruct.type} <br>
    """
  end

end
