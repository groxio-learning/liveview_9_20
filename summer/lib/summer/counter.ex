defmodule Summer.Counter do
  defstruct [:value]

  def new(value \\ 0) do
    %__MODULE__{value: value}
  end

  def inc(counter) do
    %{counter | value: counter.value + 1}
  end

  def show(counter) do
    counter.value
  end
end
