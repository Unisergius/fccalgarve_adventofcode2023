defmodule Part2Test do
  use ExUnit.Case

  describe "get_first_index/3" do
    test "finds the first index of a substring" do
      assert Advent.get_first_index("hello world", "world") == 6
    end

    test "returns nil if the substring is not found" do
      assert Advent.get_first_index("hello world", "xyz") == nil
    end

    test "finds the last index of a substring when reverse is true" do
      assert Advent.get_first_index("hello world world", "world", true) == 12
    end

    test "handles an empty string" do
      assert Advent.get_first_index("", "world") == nil
    end

    test "returns nil for an empty substring" do
      assert Advent.get_first_index("hello world", "") == nil
    end
  end

  describe "get_first_and_last_number/1" do
    setup do
      # Assuming @list is defined in Advent
      {:ok, list: Advent.module_info(:attributes)[:list]}
    end

    test "finds the first and last number correctly", %{list: list} do
      # Replace `Advent` with the actual name of your module
      assert Advent.get_first_and_last_number("one 2 three 4 five 6 sven") == 16
    end

    test "returns 0 if no numbers are found", %{list: list} do
      assert Advent.get_first_and_last_number("abc def ghi") == 0
    end

    test "handles an empty string", %{list: list} do
      assert Advent.get_first_and_last_number("") == 0
    end

    test "handles a string with only one number", %{list: list} do
      assert Advent.get_first_and_last_number("one") == 11
    end
  end
end
