defmodule Part1 do
  @moduledoc """
  Documentation for `Part1`.
  """

  @doc """

  Advent of code 2023 day 2 - balls on sack

  """

  def main() do
    get_file_contents("../input")
    |> String.split("\n")
    |> Enum.map(&calculate_all_games_score(&1))
    |> Enum.sum()
  end

  def get_file_contents(filepath) do
    case File.read(filepath) do
      {:ok, content} ->
        content

      _ ->
        :error
    end
  end

  def calculate_all_games_score(game) do
    case game do
      "" ->
        0

      _ ->
        [_, list_str] = String.split(game, ":")
        calc_game_score(list_str)
    end
  end

  def calc_game_score(list) do
    min_cubes_needed =
      String.split(list, ";")
      |> Enum.reduce(%{"red" => 0, "green" => 0, "blue" => 0}, fn cubeset, min_cubes ->
        get_min_cubes_needed(cubeset, min_cubes)
      end)

    Map.values(min_cubes_needed)
    |> Enum.reduce(1, fn element, acc ->
      case element do
        0 -> acc
        _ -> element * acc
      end
    end)
  end

  def get_min_cubes_needed(cubeset, min_cubes) do
    new_min_red_cubes =
      case Regex.run(~r/(\d+) red/, cubeset) do
        [_, number] ->
          if min_cubes["red"] < String.to_integer(number),
            do: String.to_integer(number),
            else: min_cubes["red"]

        _ ->
          min_cubes["red"]
      end

    new_min_green_cubes =
      case Regex.run(~r/(\d+) green/, cubeset) do
        [_, number] ->
          if min_cubes["green"] < String.to_integer(number),
            do: String.to_integer(number),
            else: min_cubes["green"]

        _ ->
          min_cubes["green"]
      end

    new_min_blue_cubes =
      case Regex.run(~r/(\d+) blue/, cubeset) do
        [_, number] ->
          if min_cubes["blue"] < String.to_integer(number),
            do: String.to_integer(number),
            else: min_cubes["blue"]

        _ ->
          min_cubes["blue"]
      end

    %{"red" => new_min_red_cubes, "green" => new_min_green_cubes, "blue" => new_min_blue_cubes}
  end
end

Part1.main()
|> IO.puts()
