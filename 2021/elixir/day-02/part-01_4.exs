"./day-02_input"
|> File.stream!()
|> Stream.map(&String.replace(&1, "\n", ""))
|> Enum.reduce({_position = 0, _depth = 0}, fn
  "forward " <> num, { position, depth } ->
    {position + String.to_integer(num), depth}

  "down " <> num, { position, depth } ->
    {position, depth + String.to_integer(num)}

  "up " <> num, { position, depth } ->
    {position, depth - String.to_integer(num)}
end)
|> then(fn {position, depth} -> position * depth end)
|> IO.inspect() # 1694130
