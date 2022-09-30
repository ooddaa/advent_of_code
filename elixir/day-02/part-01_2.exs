"./day-02_input"
|> File.stream!()
|> Stream.map(&String.replace(&1, "\n", ""))
|> Stream.map(fn
  "forward " <> num -> {:forward, String.to_integer(num)}
  "down " <> num -> {:down, String.to_integer(num)}
  "up " <> num -> {:up, String.to_integer(num)}
end)
|> Enum.reduce({_position = 0, _depth = 0}, fn
  { :forward, val }, { position, depth } -> { position + val, depth }
  { :down, val }, { position, depth } -> { position, depth + val }
  { :up, val }, { position, depth } -> { position, depth - val }
end)
|> then(fn {position, depth} -> position * depth end)
|> IO.inspect() # 1694130
