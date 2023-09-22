defmodule GameWeb.ReadingLive.FormComponent do
  use GameWeb, :live_component

  alias Game.Library

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage reading records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="reading-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:text]} type="text" label="Text" />
        <.input field={@form[:steps]} type="number" label="Steps" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Reading</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{reading: reading} = assigns, socket) do
    changeset = Library.change_reading(reading)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"reading" => reading_params}, socket) do
    changeset =
      socket.assigns.reading
      |> Library.change_reading(reading_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"reading" => reading_params}, socket) do
    save_reading(socket, socket.assigns.action, reading_params)
  end

  defp save_reading(socket, :edit, reading_params) do
    case Library.update_reading(socket.assigns.reading, reading_params) do
      {:ok, reading} ->
        notify_parent({:saved, reading})

        {:noreply,
         socket
         |> put_flash(:info, "Reading updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_reading(socket, :new, reading_params) do
    case Library.create_reading(reading_params) do
      {:ok, reading} ->
        notify_parent({:saved, reading})

        {:noreply,
         socket
         |> put_flash(:info, "Reading created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
