defmodule Advent do
  @moduledoc """
  Documentation for `Part2`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Part2.hello()
      :world

  """

  @list [
    {"1", 1},
    {"2", 2},
    {"3", 3},
    {"4", 4},
    {"5", 5},
    {"6", 6},
    {"7", 7},
    {"8", 8},
    {"9", 9},
    {"0", 0},
    {"zero", 0},
    {"one", 1},
    {"two", 2},
    {"three", 3},
    {"four", 4},
    {"five", 5},
    {"six", 6},
    {"seven", 7},
    {"eight", 8},
    {"nine", 9}
  ]

  def e02 do
    read_file_contents()
    |> String.split("\n", trim: true)
    |> Enum.map(&get_first_and_last_number(&1))
    |> Enum.sum()
  end

  defp read_file_contents do
    {:ok, content} = File.read("./lib/input")
    content
  end

  def get_first_and_last_number(input_string) do
    {_, first_number, _, last_number} =
      Enum.reduce(@list, {String.length(input_string), nil, 0, nil}, fn {word, value},
                                                                        {fi, fnum, li, lnum} ->
        first = get_first_index(input_string, word)
        last = get_first_index(input_string, word, true)

        new_fi = if first != nil && first <= fi, do: first, else: fi
        new_fnum = if first != nil && first <= fi, do: value, else: fnum
        new_li = if last != nil && last >= li, do: last, else: li
        new_lnum = if last != nil && last >= li, do: value, else: lnum
        {new_fi, new_fnum, new_li, new_lnum}
      end)

    IO.puts(input_string)
    IO.puts(first_number)
    IO.puts(last_number)

    if first_number == nil || last_number == nil do
      0
    else
      first_number * 10 + last_number
    end
  end

  def get_first_index(input_string, splitter, reverse \\ false) do
    parts_with_index =
      String.split(input_string, splitter)
      |> Enum.with_index()

    case reverse do
      false ->
        [{part, _index} | _] = parts_with_index
        String.length(part)

      true ->
        if Enum.count(parts_with_index) <= 1 || splitter == "" do
          nil
        else
          case reverse do
            false ->
              [{part, _index} | _] = parts_with_index
              String.length(part)

            true ->
              index = get_first_index(String.reverse(input_string), String.reverse(splitter))

              if index != nil do
                String.length(input_string) - String.length(splitter) - index
              else
                nil
              end
          end
        end
    end
  end
end

## Advent.e02()
## |> IO.puts()
