defmodule SummerWeb.CounterLive do
  alias SummerWeb.CounterComponent
  use SummerWeb, :live_view
  alias Summer.Counter

  def render(assigns) do
    ~H"""
      <.live_component module={CounterComponent} id="one">
        First
      </.live_component>

      <.live_component module={CounterComponent} id="two">
        Second
      </.live_component>
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
