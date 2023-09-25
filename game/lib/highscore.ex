defmodule Highscore do

  use GenServer

  def start_link(_initial) do
    GenServer.start_link Highscore, %{}, name: :hs
  end

  def show(pid \\ :hs) do
    GenServer.call(pid, :show)
    |> Enum.sort_by(fn {_key, val} -> -val end)
    |> Enum.take(5)
  end

  def add(pid \\ :hs, email, score) do
    GenServer.cast(pid, {:add, email, score})
  end

  # Callbacks

  @impl true
  def init(scores) do
    {:ok, scores}
  end

  @impl true
  def handle_call(:show, _from, scores) do
    {:reply, scores, scores}
  end

  @impl true
  def handle_cast({:add, email, score}, scores) do
    new_state = Map.put(scores, email, score)
    {:noreply, new_state}
  end

end
