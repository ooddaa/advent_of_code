# part 1
"input"
|> File.read!()
|> String.split("\n", trim: true)
|> Enum.map(&(String.split(&1, " ", trim: true)))
|> Enum.zip()
|> Enum.map(&(Tuple.to_list(&1) |> Enum.map(fn s -> String.to_integer(s) end)) |> Enum.sort())
|> Enum.zip_with(fn [l,r] -> abs(l-r) end)
|> Enum.sum()
# 2580760

# part 2
[left, right] = 
  "input"
|> File.read!()
|> String.split("\n", trim: true)
|> Enum.map(&(String.split(&1, " ", trim: true)))
|> Enum.zip()
|> Enum.map(&(Tuple.to_list(&1) |> Enum.map(fn s -> String.to_integer(s) end)))

freq = Enum.frequencies(right)

Enum.reduce(left, 0, fn val, acc -> acc + val * Map.get(freq, val, 0) end)
# 25358365
