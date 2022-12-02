"./day-02_input"
|> File.stream!()
|> Stream.map(&String.replace(&1, "\n", ""))
|> Stream.map(fn
  "forward " <> num -> {String.to_integer(num), 0}
  "down " <> num -> {0, String.to_integer(num)}
  "up " <> num -> {0, -String.to_integer(num)}
end)
|> Enum.reduce({_position = 0, _depth = 0}, fn
  { position_change, depth_change }, { position, depth } ->
    { position + position_change, depth + depth_change }
end)
|> then(fn {position, depth} -> position * depth end)
|> IO.inspect() # 1694130
