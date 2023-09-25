defmodule Highscore do

  use GenServer

  def start_link(_initial) do
    GenServer.start_link Highscore, %{}, name: :hs
  end

  def show(pid \\ :hs) do
    GenServer.call(pid, :show)
    |> convert()
  end

  def add(pid \\ :hs, email, score) do
    scores = GenServer.call(pid, {:add, email, score}) |> convert()

    Phoenix.PubSub.broadcast(Game.PubSub, topic(), {:new_scores, scores})

    scores
  end

  def convert(scores) do
    scores
    |> Enum.sort_by(fn {_key, val} -> -val end)
    |> Enum.take(5)
  end

  def topic do
    "highscores"
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
  def handle_call({:add, email, score}, _from, scores) do
    new_state = Map.put(scores, email, score)
    {:reply, new_state, new_state}
  end

end
