defmodule Part1 do
  @moduledoc """
  Documentation for `Part1`.
  """

  @doc """

  Advent of code 2023 day 2 - balls on sack

  """
  @game :Game
  @red_ball :red
  @green_ball :green
  @blue_ball :blue

  def main(num_red \\ 0, num_green \\ 0, num_blue \\ 0) do
    get_file_contents("../input")
    |> String.split("\n")
    |> Enum.map(&valid_game_score(&1, num_red, num_green, num_blue))
    |> Enum.sum()
  end

  def valid_game_score(game, red \\ 0, green \\ 0, blue \\ 0) do
    case game do
      "" ->
        0

      _ ->
        [game_id_str, list_str] = String.split(game, ":")
        game_id = extract_number_from_game(game_id_str)

        if is_valid_game(list_str, red, green, blue) do
          game_id
        else
          0
        end
    end
  end

  def is_valid_game(list, red \\ 0, green \\ 0, blue \\ 0) do
    String.split(list, ";")
    |> Enum.all?(&is_valid_ballset(&1, red, green, blue))
  end

  def is_valid_ballset(ballset, red \\ 0, green \\ 0, blue \\ 0) do
    String.split(ballset, ",")
    |> Enum.all?(&do_we_have_enough_balls(&1, red, green, blue))
  end

  def do_we_have_enough_balls(balls, red \\ 0, green \\ 0, blue \\ 0) do
    do_we_have_enough_balls_color(balls, "red", red) &&
      do_we_have_enough_balls_color(balls, "green", green) &&
      do_we_have_enough_balls_color(balls, "blue", blue)
  end

  def do_we_have_enough_balls_color(balls, ball_color, ball_color_quantity_available \\ 0) do
    case Regex.run(~r/(\d+) #{ball_color}/, balls) do
      [_, number] -> String.to_integer(number) <= ball_color_quantity_available
      _ -> true
    end
  end

  def extract_number_from_game(game_part) do
    case Regex.run(~r/#{@game} (\d+)/, game_part) do
      [_, number] -> String.to_integer(number)
      _ -> 0
    end
  end

  def get_file_contents(filename) do
    {:ok, content} = File.read(filename)
    content
  end
end

Part1.main(12, 13, 14)
|> IO.puts()
