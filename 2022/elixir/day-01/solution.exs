elves =
  File.read!("input")
  |> String.split("\n\n")
  |> Enum.map(&(
    String.split(&1, "\n")
    |> Enum.map(fn s -> String.to_integer(s) end)
    |> Enum.sum()
    )
  )

[head| _] = elves |> Enum.sort(:desc) |> Enum.chunk(3)
  head |> Enum.sum()
  # |> IO.inspect() # 211805
