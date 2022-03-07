defmodule QukathWeb.OrgstructLive.NestedOrgstructSlot do
  use Surface.Component

  alias Surface.Components.{LiveRedirect}
  alias QukathWeb.OrgstructLive.NestedOrgstruct 
  alias QukathWeb.Router.Helpers, as: Routes

  prop nested_orgstruct, :any, required: true
  prop parent_orgstruct, :any, required: true
  prop print_parent, :boolean, default: true
  slot default, args: [:orgstruct]


  def render(assigns) do
    ~F"""
    {#if @nested_orgstruct.id == @parent_orgstruct.id and @print_parent }
       <#slot :args={orgstruct: @parent_orgstruct}/>
    {/if}

    {#if @nested_orgstruct }
      {#for child <- @nested_orgstruct.children }
        <#slot :args={orgstruct: child}/>
        
        {#if Map.has_key?(child, :children) }
          <NestedOrgstruct nested_orgstruct={child} parent_orgstruct={@parent_orgstruct}/>
        {/if}
      {/for}
    {/if}
    """
  end

end
