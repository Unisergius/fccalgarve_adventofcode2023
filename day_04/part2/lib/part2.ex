defmodule Part2 do
  @moduledoc """
  Documentation for `Part2`.
  """

  @doc """
  Scratching cards part 2

  ## Examples
  """
  def main do
    get_file_contents("../input")
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{"available" => 1, "processed" => 0}, fn scratchcard, number_of_cards ->
      if number_of_cards["available"] > 0 do
        %{
          "available" =>
            number_of_cards["available"] + get_cards_from_scratchcard(scratchcard) - 1,
          "processed" => number_of_cards["processed"] + 1
        }
      else
        number_of_cards
      end
    end)
  end

  def play_scratch_game(scratchcard_list) do
  end

  def get_file_contents(filepath) do
    case File.read(filepath) do
      {:ok, content} -> content
      _ -> :error
    end
  end

  def get_cards_from_scratchcard(scratchcard) do
    parts =
      String.split(scratchcard, ":")
      |> Enum.at(1)
      |> String.split("|")

    winning = split_numbers(Enum.at(parts, 0))

    num =
      split_numbers(Enum.at(parts, 1))
      |> Enum.reduce(0, fn elem, points ->
        if(is_winning_number(elem, winning), do: 1, else: 0) + points
      end)

    num
  end

  def is_winning_number(number, winning_list) do
    winning_list
    |> Enum.any?(&(number == &1))
  end

  def split_numbers(number_string) do
    number_string
    |> String.split(" ", trim: true)
    |> Enum.map(fn a ->
      case Integer.parse(a) do
        {number, _} -> number
        :error -> 0
      end
    end)
  end
end
