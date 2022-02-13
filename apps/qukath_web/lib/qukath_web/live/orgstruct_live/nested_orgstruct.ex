defmodule QukathWeb.OrgstructLive.NestedOrgstruct do
  use Surface.Component

  alias Surface.Components.{LiveRedirect}
  alias QukathWeb.OrgstructLive.NestedOrgstruct 
  alias QukathWeb.Router.Helpers, as: Routes

  prop socket, :any, required: true
  prop nested_orgstruct, :any, required: true
  prop parent_orgstruct, :any, required: true
  prop orgfunc, :fun, default: nil

  defp func_attach(assigns) do
    if assigns.func do
       (assigns.func).(assigns)
    else
       print_orgstruct(assigns)
    end
  end


  def render(assigns) do
    ~F"""
    {#if @nested_orgstruct }
      {#for child <- @nested_orgstruct.children }
        <.func_attach orgstruct={child} socket={@socket} func={@orgfunc} parent_orgstruct={@parent_orgstruct}/>
        {#if Map.has_key?(child, :children) }
          <NestedOrgstruct nested_orgstruct={child} socket={@socket} orgfunc={@orgfunc} parent_orgstruct={@parent_orgstruct}/>
        {/if}
      {/for}
    {/if}
    """
  end

  def print_orgstruct(assigns) do
    ~F"""
      <LiveRedirect label={@orgstruct.name}
      to={Routes.orgstruct_show_path(@socket, :show, @orgstruct)}/> : {@orgstruct.type} 
      <LiveRedirect label="Members"
      to={Routes.employee_members_path(@socket, :members, @parent_orgstruct, @orgstruct)}/>  <br>
    """
  end


end
