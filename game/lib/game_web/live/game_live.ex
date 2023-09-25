defmodule GameWeb.GameLive do
  use GameWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="text-xl">
      <%= Game.show(@game) %>
    </div>
    <div class="text-xl">
      <%= @game.score %>
    </div>

    <div id="scoreboard">
      <%= inspect @scoreboard, pretty: true %>
    </div>

    <.simple_form
      for={@form}
      id="guess-form"
      phx-change="validate"
      phx-submit="guess">
        <.input field={@form[:guess]} type="text" label="Guess" />
        <:actions>
          <.button phx-disable-with="Checking...">Guess</.button>
        </:actions>
    </.simple_form>

    """
  end

  def mount(%{"id" => id}, _session, socket) do
    reading = Game.Library.get_reading! id

    socket = assign(socket,
      game: Game.new(reading.text, reading.steps),
      scoreboard: Highscore.show()
    )

    Phoenix.PubSub.subscribe(Game.PubSub, Highscore.topic())

    {:ok, socket |> clear_form() }
  end

  defp clear_form(socket) do
    assign(socket,
      form: changeset(%{}) |> build_form()
    )
  end

  def handle_params(_params, _url, socket) do
    email = socket.assigns.current_user.email
    score = socket.assigns.game.score

    socket = cond do
      socket.assigns.live_action == :done ->
        assign(socket, :scoreboard, Highscore.add(email, score))
      true -> socket
    end

    {:noreply, socket}
  end

  def handle_event("validate", params, socket) do
    updated = params["game"] |> changeset() |> build_form()
    {:noreply, assign(socket, :form, updated)}
  end

  def handle_event("guess", params, socket) do
    changes = params["game"] |> changeset()

    socket = case socket.assigns.game do
      %{steps: []} -> push_patch(socket, to: ~p"/done")
      game -> guess(socket, changes)
    end |> clear_form()

    {:noreply, socket}
  end

  def handle_info({:new_scores, scores}, socket) do

    {:noreply, assign(socket, :scoreboard, scores)}
  end

  defp guess(socket, changeset) do
   if changeset.valid? do
      guess = Ecto.Changeset.get_field(changeset, :guess)
      game = Game.guess(socket.assigns.game, guess)
      assign(socket, game: game)
    else
      put_flash(socket, :error, "Type more")
    end
  end


  def changeset(params) do
    {%{guess: nil}, %{guess: :string}}
    |> Ecto.Changeset.cast(params, [:guess])
    |> Ecto.Changeset.validate_length(:guess, min: 4)
    |> struct!(action: :validate)
  end

  def build_form(changeset) do
    changeset |> to_form(as: :game)
  end
end
