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
    |> String.split("\n", trim: true)
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
    IO.puts(scratchcard)

    parts =
      String.split(scratchcard, ":")
      |> Enum.at(1)
      |> String.split("|")

    winning = split_numbers(Enum.at(parts, 0))

    num_winning_numbers =
      split_numbers(Enum.at(parts, 1))
      |> Enum.reduce(0, fn elem, points ->
        if(is_winning_number(elem, winning), do: 1, else: 0) + points
      end)

    case num_winning_numbers do
      0 -> 0
      _ -> Integer.pow(2, num_winning_numbers - 1)
    end
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
