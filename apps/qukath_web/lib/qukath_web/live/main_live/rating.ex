defmodule Rating do
  use Surface.LiveComponent

  @doc "The maximum value"
  prop max, :integer, default: 5

  @doc "The content"
  slot default, args: [:value, :max]

  data value, :integer, default: 1

  def render(assigns) do
    ~F"""
    <div>
      <p>
        <#slot :args={value: @value, max: @max} />
      </p>
      <div style="padding-top: 10px;">
        <button class="button is-info" :on-click="dec" disabled={@value == 1}>
          -
        </button>
        <button class="button is-info" :on-click="inc" disabled={@value == @max}>
          +
        </button>
      </div>
    </div>
    """
  end

  def handle_event("inc", _, socket) do
    {:noreply, update(socket, :value, &(&1 + 1))}
  end

  def handle_event("dec", _, socket) do
    {:noreply, update(socket, :value, &(&1 - 1))}
  end
end
