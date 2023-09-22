defmodule GameWeb.ReadingLive.Show do
  use GameWeb, :live_view

  alias Game.Library

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:reading, Library.get_reading!(id))}
  end

  defp page_title(:show), do: "Show Reading"
  defp page_title(:edit), do: "Edit Reading"
end
