defmodule QukathWeb.OrgstructLive.NestedOrgstruct do
  use Surface.Component

  # alias Surface.Components.Link
  alias QukathWeb.OrgstructLive.NestedOrgstruct 

  prop nested_orgstruct, :any, required: true

  def render(assigns) do
    ~F"""
    {#if @nested_orgstruct }
      {#for child <- @nested_orgstruct.children }
        <.print_orgstruct orgstruct={child} />
        {#if Map.has_key?(child, :children) }
          <NestedOrgstruct nested_orgstruct={child} />
        {/if}
      {/for}
    {/if}
    """
  end

  defp print_orgstruct(assigns) do
    ~F"""
      {@orgstruct.name}
      {@orgstruct.entity_id}
      {@orgstruct.entity.parent_id}
      <br/>
    """
  end

end