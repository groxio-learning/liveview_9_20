defmodule Phoenix.PubSub.Nats.Server do
  use GenServer

  def start_link(config) do
    GenServer.start_link(__MODULE__, config, name: __MODULE__)
  end

  def init(config) do
    {:ok, conn} = Nats.Client.start_link(name: Phoenix.PubSub.Nats.Client)
    {:ok, sid} = Nats.Client.sub(conn, "Phoenix.PubSub.Nats.*")

    state = %{
      config: config,
      conn: conn,
      sid: sid,
      node_name: node()
    }

    {:ok, state}
  end

  def handle_info(%Nats.Protocol.Msg{} = msg, state) do
    <<"Phoenix.PubSub.Nats.", topic::binary>> = msg.subject
    {
      adapter_name,
      target,
      node_name,
      message,
      dispatcher
    } = :erlang.binary_to_term(msg.payload)

    if (target == :only && node_name == state.node_name) or (target == :except && node_name != state.node_name) do
      Phoenix.PubSub.local_broadcast(adapter_name, topic, message, dispatcher)
    end

    {:noreply, state}
  end
end
