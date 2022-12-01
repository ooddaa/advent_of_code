"./day-03_input"
|> File.stream!()
|> Stream.map(&String.replace(&1, "\n", ""))
|> Stream.map(fn str ->
  str
  |> String.trim()
  |> String.split("", trim: true)
  |> Enum.map(&String.to_integer/1)
end)
|> Stream.zip()
|> Stream.map(fn tuple ->
  list = Tuple.to_list(tuple)
  len = length(list)
  sum = Enum.sum(list)

  # convert boolean to integer bool (&& 1 || 0)
  gamma_rate = sum > len/2 && 1 || 0
  epsilon_rate = sum < len/2 && 1 || 0

  [ gamma_rate, epsilon_rate ]
end)
|> Stream.zip()
|> Stream.map(&(Enum.join(Tuple.to_list(&1),""))) # put back binary number
|> Enum.map(&(Integer.parse(&1, 2))) # parse to base10 [{2346, ""}, {1749, ""}]
|> then(fn [{gamma, _}, {epsilon, _}] -> gamma * epsilon end)
# |> IO.inspect() # 4103154
