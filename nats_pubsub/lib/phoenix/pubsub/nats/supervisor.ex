defmodule Phoenix.PubSub.Nats.Supervisor do
  use Supervisor

  def start_link(config) do
    Supervisor.start_link(__MODULE__, config, name: __MODULE__)
  end

  def init(config) do
    children = [
      %{
        id: Phoenix.PubSub.Nats.Server,
        start: {Phoenix.PubSub.Nats.Server, :start_link, [config]}
      }
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
