import Bitwise

numbers =
  "./day-03_input"
  |> File.stream!()
  |> Stream.map(&String.replace(&1, "\n", ""))
  |> Enum.map(&(&1 |> String.to_charlist() |> List.to_tuple()))
  # [{48, 49, 48, 48, 48, 49, 49, 49, 48, 48, 48, 49},]
  # |> Enum.take(4)
  |> Enum.map(&(&1))


# numbers
# |> IO.inspect()

len = tuple_size(Enum.at(numbers, 1))
half = div(length(numbers),2)

# IO.inspect(len)
gamma_as_list =
  for pos <- 0..len - 1 do
    zeros = Enum.count_until(numbers, &(elem(&1, pos) == ?0), half + 1)
    # IO.inspect(zeros)
    if zeros > half, do: ?0, else: ?1
  end

gamma = List.to_integer(gamma_as_list, 2)
mask = 2**len - 1
epsilon = bnot(gamma) &&& mask

# IO.inspect(gamma)
# IO.inspect(mask)
# IO.inspect(epsilon)

# IO.inspect(gamma * epsilon) # 4103154
