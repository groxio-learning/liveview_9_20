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
    )

    {:ok, socket |> clear_form() }
  end

  defp clear_form(socket) do
    assign(socket,
      form: changeset(%{}) |> build_form()
    )
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

  def handle_event("validate", params, socket) do
    updated = params["game"] |> changeset() |> build_form()
    {:noreply, assign(socket, :form, updated)}
  end

  def handle_event("guess", params, socket) do
    changes = params["game"] |> changeset()
    {:noreply, guess(socket, changes) |> clear_form() }
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
