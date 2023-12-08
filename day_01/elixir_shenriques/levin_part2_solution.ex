defmodule DayOne do

    def find_number_in_word(word) do
     
      occs = 
        for number <- ["one", "two", "three", "four", "five", "six", "seven", "eigh", "nine"] do
        String.starts_with?(word, number)      
      end
      |> Enum.with_index(1)
      |> Enum.filter(fn {value, _number} -> value == true end)
      |> List.first()
  
      case occs do
        nil -> 
          nil
        {_value, number} -> 
          number
        end
    end
  
    def convert_nstr_to_numbers(word_list) do
      Enum.map(word_list,
       fn char ->
       
        
          try do
            String.to_integer(char)
          rescue 
            ArgumentError -> char
          end
        
       
      end)
    end
  
    def get_numbers(list_one, list_two) do
      indexed_list_one = list_one |> Enum.with_index()
      indexed_list_two = list_two |> Enum.with_index()
  
      first = Enum.reject(indexed_list_one, fn {number?, _index} -> not is_number(number?) end)
      second = Enum.reject(indexed_list_two, fn {number?, _index} -> not is_number(number?) end)
  
      combined_numbers = Enum.concat(first, second)
      smallest_index = 
        Enum.map(combined_numbers, fn {_number, index} -> index end)
        |> Enum.sort()
        |> List.first()
  
      tallest_index = 
        Enum.map(combined_numbers, fn {_number, index} -> index end)
        |> Enum.sort()
        |> List.last()
        
      smallest_number = 
        Enum.filter(combined_numbers, fn {_number, index} -> index == smallest_index end) 
        |> Enum.map(fn {number, _idx} -> number end)
        |> List.first()
      tallest_number = 
        Enum.filter(combined_numbers, fn {_number, index} -> index == tallest_index end) 
        |> Enum.map(fn {number, _index} -> number end)
        |> List.first()
      
      #String.to_integer("#{smallest_number}#{tallest_number}")
  
      {smallest_number,tallest_number}
  
    end
  end
  
  words = 
    String.split(data, "\n", trim: true)
    |> Enum.map(&(String.split(&1, "", trim: true)))
  
  word_tuples = 
    for word_list <- words do
    word_length = length(word_list)
    first_wordlist = DayOne.convert_nstr_to_numbers(word_list)
    
    second_wordlist = 
      for x <- 0..word_length do
        word_list
         |> Enum.join("") 
         |> String.slice(x..100)
         |> DayOne.find_number_in_word()
      end
  
  
      {first_wordlist, second_wordlist}
    end
  
  
  number_tuples = for {list_one, list_two} <- word_tuples do
    DayOne.get_numbers(list_one, list_two)
  end
  
  Enum.map(number_tuples, fn {tens, ones} -> String.to_integer("#{tens}#{ones}") end)
  |> Enum.sum()