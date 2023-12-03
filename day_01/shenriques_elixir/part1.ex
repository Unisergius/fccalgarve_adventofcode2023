defmodule Advent do
  def e01 do
    read_file_contents()
    |> String.split()
    |> Enum.map(&get_line_numbers(&1))
    |> Enum.map(&get_first_and_last_characters(&1))
    |> Enum.map(&String.to_integer(&1))
    |> Enum.sum()
  end

  defp read_file_contents do
    {:ok, content} = File.read("../input")
    content
  end

  defp get_line_numbers(input_string) do
    Regex.replace(~r/[^0-9]*/, input_string, "")
  end

  defp get_first_and_last_characters(converted_string) do
    String.first(converted_string) <> String.last(converted_string)
  end
end

Advent.e01()
|> IO.puts()
