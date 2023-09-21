defmodule SummerWeb.CounterComponent do
  use SummerWeb, :live_component
  alias Summer.Counter

  slot :inner_block

  def render(assigns) do
    ~H"""
    <button phx-click="clicked" phx-target={@myself} class="w-32 border border-2">
      <%= render_slot(@inner_block) %>
      <%= Counter.show(@counter) %>
    </button>
    """
  end

  def mount(socket) do
    {:ok, assign(socket, :counter, Counter.new)}
  end

  def handle_event(_event, _params, socket) do
    %{counter: counter} = socket.assigns

    {:noreply, assign(socket, :counter, Counter.inc(counter))}
  end
end
