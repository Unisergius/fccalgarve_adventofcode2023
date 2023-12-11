defmodule Part1 do
  @moduledoc """
  Documentation for `Part1`.
  """

  @doc """
  sums all the valid numbers

  ## Examples

  """
  def main do
    get_file_contents("../input")
    |> String.split()
    |> Enum.reduce(%{"valid" => [], "pending" => []})
  end

  def get_file_contents(filepath) do
    case File.read(filepath) do
      {:ok, content} -> content
      _ -> :error
    end
  end
end
