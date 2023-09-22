defmodule Game do
  def new(sentence, steps, randomize \\ &Enum.shuffle/1) do
    length = String.length(sentence)
    chunk_size = (length / steps) |> ceil
    steps = randomize.(1..length) |> Enum.chunk_every(chunk_size)
    %{original: sentence, sentence: sentence, steps: steps}
  end

  def erase(game) do
    sentence = String.graphemes(game.sentence) |> Enum.with_index(1)
    [step | tail] = game.steps
    # sentence {"a", 0}, {"b", 1}, {"c", 2}
    new_sentence =
      Enum.map(sentence, fn {char, sentence_i} ->
        cond do
          char in [".", ",", "'", " "] -> char
          sentence_i in step -> "_"
          true -> char
        end
      end)
      |> Enum.join

    %{game | steps: tail, sentence: new_sentence}
  end

  def show(game) do
    game.sentence
  end

end
