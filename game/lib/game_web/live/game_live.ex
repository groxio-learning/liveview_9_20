defmodule GameWeb.GameLive do
  use GameWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="text-xl">
      <%= Game.show(@game) %>
    </div>

    <button :if={@live_action == :game} phx-click="erase" class="w-32 border border-2">
      Erase
    </button>
    """
  end

  def mount(%{"id" => id}, _session, socket) do
    reading = Game.Library.get_reading! id

    socket = assign(socket,
      game: Game.new(reading.text, reading.steps)
    )

    {:ok, socket}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  def handle_event("erase", _params, socket) do
    %{game: game} = socket.assigns

    socket = case game do
      %{steps: []} -> push_patch(socket, to: ~p"/done")
      game ->
        game = Game.erase(game)
        assign(socket, :game, game)
    end

    {:noreply, socket}
  end
end
