defmodule Part1Test do
  use ExUnit.Case
  doctest Part1

  test "extract_number_from_game extracts correct number" do
    assert Part1.extract_number_from_game("Game 123") == 123
  end

  test "extract_number_from_game returns 0 for invalid input" do
    assert Part1.extract_number_from_game("Invalid input") == 0
  end

  test "is_valid_game returns true for a valid game" do
    valid_game = "1 red, 2 green; 3 blue"
    assert Part1.is_valid_game(valid_game, 1, 2, 3)
  end

  test "is_valid_game returns false for an invalid game" do
    invalid_game = "1 red, 4 green; 3 blue"
    assert not Part1.is_valid_game(invalid_game, 1, 2, 3)
  end

  test "do_we_have_enough_balls_color returns false not enough blue balls" do
    ball_set = "2 blue"
    assert not Part1.do_we_have_enough_balls_color(ball_set, "blue", 3)
  end

  test "do_we_have_enough_balls_color return true no red balls needed" do
    ball_set = "0 red"
    assert not Part1.do_we_have_enough_balls_color(ball_set, "blue", 2)
  end
end
