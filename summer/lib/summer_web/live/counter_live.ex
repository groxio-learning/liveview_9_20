defmodule SummerWeb.CounterLive do
  use SummerWeb, :live_view
  alias Summer.Counter

  def render(assigns) do
    ~H"""
      <div>
        <.counter counter={@counter}>
          Clicks
        </.counter>
      </div>
    """
  end

  attr :counter, Counter, required: true
  slot :inner_block
  def counter(assigns) do
    ~H"""
      <button class="border border-1" phx-click="inc">
        <%= render_slot(@inner_block) %>
        <%= Counter.show(@counter) %>
      </button>
      <pre>
        <%= inspect(assigns, pretty: true) %>
      </pre>
    """
  end

  def handle_event("inc", _meta, socket) do
    {:noreply, inc(socket)}
  end

  def inc(socket) do
    assign(socket, :counter, Counter.inc(socket.assigns.counter))
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :counter, Counter.new)}
  end
end
