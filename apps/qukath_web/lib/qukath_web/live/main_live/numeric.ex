defmodule QukathWeb.Numeric do
  use Surface.Component

  @doc "The field name"
  prop numbers, :list, required: true

  slot default, args: [:num]

  def render(assigns) do
    ~F"""
    {#for number <- @numbers}
        <#slot :args={num: number}/>
    {/for}
    """
  end
end
