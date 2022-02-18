defmodule Card do
  use Surface.Component

  @doc "The header"
  slot header

  @doc "The footer"
  slot footer

  @doc "The main content"
  slot default, required: true

  def render(assigns) do
    ~F"""
    <div class="card">
      <header class="card-header" style="background-color: #f5f5f5">
        <p class="card-header-title">
          <#slot name="header" />
        </p>
      </header>
      <div class="card-content">
        <div class="content">
          <#slot />
        </div>
      </div>
      <footer class="card-footer" style="background-color: #f5f5f5">
        <#slot name="footer" />
      </footer>
    </div>
    """
  end
end
