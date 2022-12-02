"./day-02_input"
|> File.stream!()
|> Stream.map(&String.replace(&1, "\n", ""))
|> Enum.reduce({_position = 0, _depth = 0, _aim = 0}, fn
  "forward " <> num, { position, depth, aim } ->
    {position + String.to_integer(num), depth + aim * String.to_integer(num), aim}

  "down " <> num, { position, depth, aim } ->
    {position, depth, aim + String.to_integer(num)}

  "up " <> num, { position, depth, aim } ->
    {position, depth, aim - String.to_integer(num)}
end)
|> then(fn {position, depth, _aim} -> position * depth end)
|> IO.inspect() # 1698850445
