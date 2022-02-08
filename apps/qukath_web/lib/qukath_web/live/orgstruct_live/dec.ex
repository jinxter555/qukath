defmodule Dec do
  use Surface.Component

  prop value, :integer, default: 5

  def v(assigns) do
    ~F"""
    <br/>
    what is value {@value }
    """
  end

  def render(assigns) do
    ~F"""
    {#if @value > 0}
      {@value}
      <Dec value={@value-1}/>
      {v(assigns) }
    {/if}
    """
  end
end
