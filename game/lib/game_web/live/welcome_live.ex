defmodule GameWeb.WelcomeLive do

  use GameWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="text-strong">Welcome</div>
    <div class="m-6">
      <button class="border border-2 w-32" phx-click="previous">Previous</button>
      <button class="border border-2 w-32" phx-click="pick">Pick Quote</button>
      <button class="border border-2 w-32" phx-click="next">Next</button>
    </div>
    <div class="m6">
      <%= @current_quote.name %>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    quotes = Game.Repo.all Game.Library.Reading
    socket = assign(socket, quotes: quotes, current_quote: List.first(quotes), quote_index: 0)
    {:ok, socket}
  end

  def handle_event("pick", meta, socket) do
    {:noreply, push_navigate(socket, to: ~p"/game/#{socket.assigns.current_quote}") }
  end

  def handle_event("previous", meta, socket) do
    socket = navigate(socket, -1)

    {:noreply, socket }
  end

  def handle_event("next", meta, socket) do
    socket = navigate(socket, 1)

    {:noreply, socket }
  end

  def navigate(socket, offset) do
    index = socket.assigns.quote_index
    next_index = rem(index + offset, length(socket.assigns.quotes))
    current_quote = Enum.at(socket.assigns.quotes, next_index)
    assign(socket, current_quote: current_quote, quote_index: next_index)
  end

end
