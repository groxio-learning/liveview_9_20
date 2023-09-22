defmodule GameWeb.ReadingLive.Index do
  use GameWeb, :live_view

  alias Game.Library
  alias Game.Library.Reading

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :readings, Library.list_readings())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Reading")
    |> assign(:reading, Library.get_reading!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Reading")
    |> assign(:reading, %Reading{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Readings")
    |> assign(:reading, nil)
  end

  @impl true
  def handle_info({GameWeb.ReadingLive.FormComponent, {:saved, reading}}, socket) do
    {:noreply, stream_insert(socket, :readings, reading)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    reading = Library.get_reading!(id)
    {:ok, _} = Library.delete_reading(reading)

    {:noreply, stream_delete(socket, :readings, reading)}
  end
end
