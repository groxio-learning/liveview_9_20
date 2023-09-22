defmodule GameTest do
  use ExUnit.Case
  import Game

  test "CRC" do
    actual =
      game_fixture()
      |> erase()
      |> assert_key(:sentence, "___de")
      |> erase()
      |> assert_key(:sentence, "_____")
      |> show()
  end

  def assert_key(game, key, actual) do
    assert Map.fetch!(game, key) == actual
    game
  end

  def game_fixture do
    sentence = "abcde"
    steps = 2
    function = &Function.identity/1
    new sentence, steps, function
  end
end
