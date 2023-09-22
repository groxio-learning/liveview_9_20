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

    <pre>
      <%= inspect(assigns, pretty: true) %>
    </pre>
    """
  end

  def mount(_params, _session, socket) do
    socket = assign(socket,
      game: Game.new("Have you tried restarting it?", 3)
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
