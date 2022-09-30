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
# {mask, ""} = Integer.parse("111111111111", 2)
# IO.inspect(gamma, label: "gamma") # 4095
# IO.inspect(Integer.to_string(gamma, 2), label: "gamma") # "100100101010"
# IO.inspect(bnot(gamma), label: "bnot(gamma)") # 4095
# IO.inspect(Integer.to_string(bnot(gamma), 2), label: "bnot(gamma)") # 4095
# IO.inspect(mask, label: "mask") # 4095
# IO.inspect(Integer.to_string(mask, 2), label: "mask") # "111111111111"
# IO.inspect(bnot(gamma) &&& mask, label: "bnot(gamma) &&& mask") # 1749
# IO.inspect(Integer.to_string(bnot(gamma) &&& mask, 2), label: "bnot(gamma) &&& mask") # "11011010101"

#  100100101010 gamma
#  011011010101 bnot(gamma)
#  111111111111
#  011011010101
#   11011010101 ffs

# -100100101011 bnot(gamma) - this is not correct representation ffs
# IO? treats first 0 as negative sign
epsilon = bnot(gamma) &&& mask

# IO.inspect(gamma)
# IO.inspect(mask)
# IO.inspect(epsilon)

IO.inspect(gamma * epsilon) # 4103154
