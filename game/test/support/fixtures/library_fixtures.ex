defmodule Game.LibraryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Game.Library` context.
  """

  @doc """
  Generate a reading.
  """
  def reading_fixture(attrs \\ %{}) do
    {:ok, reading} =
      attrs
      |> Enum.into(%{
        name: "some name",
        text: "some text",
        steps: 42
      })
      |> Game.Library.create_reading()

    reading
  end
end
