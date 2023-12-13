defmodule Part1Test do
  use ExUnit.Case
  doctest Part1

  test "split numbers into integer list" do
    assert Part1.split_numbers("1 2 3 4") == [1, 2, 3, 4]
  end

  test "split number into a single integer list" do
    assert Part1.split_numbers("1") == [1]
  end

  test "check winning number" do
    assert Part1.check_winning_number(2, [1, 2, 3]) == 1
  end
end
