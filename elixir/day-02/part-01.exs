"./day-02_input"
|> File.stream!()
|> Stream.map(&String.replace(&1, "\n", ""))
|> Stream.map(&String.split(&1, " "))
|> Stream.map(fn [dir, val] -> {String.to_atom(dir), String.to_integer(val)} end)
|> Enum.reduce(%{horizontal: 0, depth: 0}, fn
  {:forward, val}, acc -> Map.put(acc, :horizontal, Map.get(acc, :horizontal) + val)
  {:down, val}, acc -> Map.put(acc, :depth, Map.get(acc, :depth) + val)
  {:up, val}, acc -> Map.put(acc, :depth, Map.get(acc, :depth) - val)
  _, acc -> acc
end)
|> Enum.reduce(1, fn {_, val}, acc -> acc * val end)
# 1694130
|> IO.inspect()
