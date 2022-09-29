
"./day-01_input"
|> File.stream!()
|> Stream.map(&String.replace(&1, "\n", ""))
|> Stream.map(&String.to_integer/1)
|> Stream.chunk_every(3,1, :discard)
|> Stream.chunk_every(2,1, :discard)
# |> Enum.map(&(&1))
# |> Enum.take(10)
|> Enum.count(fn [left, right] -> Enum.sum(left) < Enum.sum(right) end)
|> IO.inspect() # 1589
