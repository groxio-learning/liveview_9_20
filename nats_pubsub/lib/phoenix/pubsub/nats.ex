defmodule Phoenix.PubSub.Nats do
  @behaviour Phoenix.PubSub.Adapter

  @impl true

  def child_spec(config) do
    Phoenix.PubSub.Nats.Supervisor.child_spec(config)
  end

  @impl true

  def broadcast(adapter_name, topic, message, dispatcher) do
    publish(adapter_name, :except, node_name(adapter_name), topic, message, dispatcher)
  end

  @impl true

  def direct_broadcast(adapter_name, node_name, topic, message, dispatcher) do
    publish(adapter_name, :only, node_name, topic, message, dispatcher)
  end

  @impl true

  def node_name(_adapter_name) do
    node()
  end

  defp publish(adapter_name, target, node_name, topic, message, dispatcher) do
    payload = :erlang.term_to_binary({adapter_name, target, node_name, message, dispatcher})
    Nats.Client.pub(Phoenix.PubSub.Nats.Client, "Phoenix.PubSub.Nats.#{topic}", payload: payload)
  end

end
