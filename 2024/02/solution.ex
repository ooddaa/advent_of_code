defmodule Day2 do
  
  def read_input(name \\ "input") do 
    name
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&(String.split(&1, " ")) |> Enum.map(fn s -> String.to_integer(s) end))
  end 

  def need_name(input) do 
    Enum.reduce(input, 0, &reducer/2)
  end

  defp reducer(level, acc) do 
    result = 
      with true <- first_check(level),
        true <- second_check(level) do 
        1
      else 
        false -> 
          case problem_dampener(level) do 
             true -> 1 
             false -> 0
          end 
         _ -> 
          0
    end
    acc + result
  end

  defp first_check([]), do: {:error, []} 
  defp first_check(level) do 
    [first | rest] = level 
    [last | _ ] = Enum.reverse(rest)
    if (abs(first - last) < 4), do: {:error, level}
    true
  end
 
  defp second_check(level) do
    chunks = Enum.chunk_every(level, 2, 1, :discard)
    [[a,b] | _rest] = chunks

    if (a < b) do 
          # asc 
          Enum.all?(chunks, fn [a,b] -> (b - a) > 0 && (b - a) < 4 end) 
    else 
       # decs
          Enum.all?(chunks, fn [a,b] -> (a - b) > 0 && (a - b) < 4 end) 
    end
  end

  def problem_dampener(level) do 
    levels = for i <- 0..(length(level)-1), do: List.delete_at(level, i)
    Enum.any?(levels, &second_check/1)
  end

end

Day2.read_input("input") 
|> Day2.need_name()
|> IO.inspect()
