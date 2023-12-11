defmodule Part1 do
  @moduledoc """
  Documentation for `Part1`.
  """

  @doc """
  Scratching cards part 1

  ## Examples
  """
  def main do
    get_file_contents("../input")
    |> String.split("\n")
    |> Enum.reduce(0, fn scratchcard, points ->
      points + get_points_from_scratchcard(scratchcard)
    end)
  end

  def get_file_contents(filepath) do
    case File.read(filepath) do
      {:ok, content} -> content
      _ -> :error
    end
  end

  def get_points_from_scratchcard(scratchcard) do
    parts = String.split(scratchcard, "|", trim: true)
    winning = split_numbers(parts.first())

    num_points =
      split_numbers(parts.last())
      |> Enum.reduce(0, fn elem, points -> check_winning_number(elem, winning) + points end)

    case num_points do
      0 -> 0
      _ -> Integer.pow(2, num_points - 1)
    end
  end

  def check_winning_number(number, winning_list) do
    winning_list
    |> Enum.map(&if number == &1, do: 1, else: 0)
    |> Enum.sum()
  end

  def split_numbers(number_string) do
    number_string
    |> String.split(" ")
    |> Enum.map(fn a ->
      case Integer.parse(a) do
        {number, _} -> number
        :error -> 0
      end
    end)
  end
end
