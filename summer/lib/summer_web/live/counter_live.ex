defmodule SummerWeb.CounterLive do
  use SummerWeb, :live_view
  alias Summer.Counter

  def render(assigns) do
    ~H"""
      <button class="border border-1" phx-click="inc">
        <%= Counter.show(@counter) %>
      </button>
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
