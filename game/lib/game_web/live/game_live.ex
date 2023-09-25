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
      <%= inspect @form, pretty: true %>
    </pre>
    """
  end

  def mount(%{"id" => id}, _session, socket) do
    reading = Game.Library.get_reading! id

    socket = assign(socket,
      game: Game.new(reading.text, reading.steps),
      form: form_changeset(%{})
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

  def form_changeset(params) do
    {%{guess: nil}, %{guess: :string}}
    |> Ecto.Changeset.cast(params, [:guess])
    |> Ecto.Changeset.validate_length(:guess, min: 4)
    |> to_form(as: :game)
  end
end
