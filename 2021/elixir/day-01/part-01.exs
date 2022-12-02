# https://adventofcode.com/2021/day/1

"./day-01_input"
|> File.stream!()
|> Stream.map(&String.replace(&1, "\n", ""))
|> Stream.map(&String.to_integer/1)
|> Stream.chunk_every(2,1, :discard)
|> Enum.count(fn [left, right] -> left < right end)
|> IO.inspect()
