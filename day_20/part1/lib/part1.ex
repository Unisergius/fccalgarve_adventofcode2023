defmodule Part1 do
  @moduledoc """
  Documentation for `Part1`.
  """

  @doc """
  Module compiler 
  i
  ## Examples

  """

  require Logger

  def init(number_of_button_pushes) do
    :ets.new(:part1, [:named_table])

    :ets.insert(:part1, {:high, 0})
    :ets.insert(:part1, {:low, 0})

    _module_map =
      readfile("../input")
      |> String.split("\n", trim: true)
      |> Enum.map(fn element -> parse_module_map(element) end)
      |> Enum.map(fn element -> map_origin_modules(element) end)

    push_button(number_of_button_pushes)

    [{_, num_highs}] = :ets.lookup(:part1, :high)
    [{_, num_lows}] = :ets.lookup(:part1, :low)

    :ets.delete(:part1)

    IO.puts("highs #{num_highs}")
    IO.puts("lows #{num_lows}")
    IO.puts("result #{num_highs * num_lows}")
    {:ok, num_highs * num_lows}
  end

  def push_button(number_of_times) do
    # push button a number of times
    1..number_of_times
    |> Enum.each(fn i ->
      IO.puts("Push button #{i}")
      send_pulse(:low, "broadcaster")
    end)
  end

  def parse_module_map(elementString) do
    module_map =
      String.split(elementString, "->", trim: true)
      |> Enum.map(fn elem -> String.trim(elem) end)

    destination_list =
      String.split(Enum.at(module_map, 1), ",", trim: true)
      |> Enum.map(fn elem -> String.trim(elem) end)

    case Enum.at(module_map, 0) do
      "broadcaster" ->
        :ets.insert(:part1, {"broadcaster", "broadcaster", destination_list, []})
        %{id: "broadcaster", func: "broadcaster", dest: destination_list, mem: []}

      "%" <> id ->
        :ets.insert(:part1, {id, "%", destination_list, :low})
        %{id: id, func: "%", dest: destination_list, mem: :low}

      "&" <> id ->
        :ets.insert(:part1, {id, "&", destination_list, []})
        %{id: id, func: "&", dest: destination_list, mem: []}
    end
  end

  def map_origin_modules(module) do
    case :ets.lookup(:part1, module[:id]) do
      [] ->
        :error

      [{id, _func, destination_list, _state}] ->
        Enum.map(destination_list, fn destination_module_id ->
          add_input_module(id, destination_module_id)
        end)
    end
  end

  def add_input_module(module_id, destination_module_id) do
    case :ets.lookup(:part1, destination_module_id) do
      [] ->
        :ok

      [{id, func, dest_list, input_list}] ->
        case func do
          "&" -> :ets.insert(:part1, {id, "&", dest_list, [{module_id, :low} | input_list]})
          _ -> :ok
        end
    end
  end

  def send_pulse(pulse, destination_module_id) do
    send_pulse(pulse, destination_module_id, nil)
  end

  def send_pulse(pulse, destination_module_id, origin_module_id) do
    [{_, pulse_count}] = :ets.lookup(:part1, pulse)
    :ets.insert(:part1, {pulse, pulse_count + 1})

    case :ets.lookup(:part1, destination_module_id) do
      [] ->
        :ok

      [{id, func, dest_list, mem}] ->
        IO.puts(
          "#{origin_module_id} --#{pulse}-->  (#{func})#{destination_module_id} [#{print_mem(mem)}]: #{pulse_count + 1} "
        )

        case func do
          "&" -> conjunction_action(pulse, {id, func, dest_list, mem}, origin_module_id)
          "%" -> flip_flop_action(pulse, {id, func, dest_list, mem})
          "broadcaster" -> broadcaster_action(pulse, {id, func, dest_list, mem})
          _ -> :error
        end
    end
  end

  def broadcaster_action(pulse, broadcaster_module) do
    case broadcaster_module do
      {id, _func, dest_list, _mem} ->
        for dest_module <- dest_list do
          send_pulse(pulse, dest_module, id)
        end

        :ok

      _ ->
        :error
    end
  end

  def flip_flop_action(pulse, flip_flop_module) do
    case pulse do
      :high ->
        :ok

      :low ->
        case flip_flop_module do
          {id, func, destination_list, state} ->
            :ets.insert(:part1, {id, func, destination_list, toggle(state, destination_list, id)})

          _ ->
            :error
        end

        :ok
    end
  end

  defp toggle(pulse, destination_list, origin_module_id) do
    new_pulse =
      case pulse do
        :high -> :low
        _ -> :high
      end

    for module_id <- destination_list do
      send_pulse(new_pulse, module_id, origin_module_id)
    end

    new_pulse
  end

  def conjunction_action(pulse, conjunction_module, origin_module_id) do
    case conjunction_module do
      {id, func, destination_list, mem} ->
        new_mem =
          Enum.map(mem, fn {elem_module_id, elem_module_pulse} ->
            if(elem_module_id == origin_module_id,
              do: {elem_module_id, pulse},
              else: {elem_module_id, elem_module_pulse}
            )
          end)

        :ets.insert(:part1, {id, func, destination_list, new_mem})

        if Enum.all?(new_mem, fn {_, elem} -> elem == :high end) do
          Enum.each(destination_list, fn module_id -> send_pulse(:low, module_id, id) end)
        else
          Enum.each(destination_list, fn module_id -> send_pulse(:high, module_id, id) end)
        end

        :ok

      _ ->
        :error
    end
  end

  def readfile(file_content) do
    case File.read(file_content) do
      {:ok, content} -> content
      _ -> :error
    end
  end

  defp print_mem(mem) do
    case mem do
      :low ->
        "off"

      :high ->
        "on"

      [] ->
        "empty"

      _ ->
        Enum.reduce(mem, "", fn {module, pulse}, acc ->
          acc <> " {" <> module <> ": " <> print_pulse(pulse) <> "}"
        end)
    end
  end

  defp print_pulse(:high) do
    "high"
  end

  defp print_pulse(:low) do
    "low"
  end
end
