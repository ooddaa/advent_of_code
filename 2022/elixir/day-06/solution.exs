part1 = 4 # 1647
part2 = 14 # 2447

File.read!("input")
  |> String.split("", trim: true)
  |> Enum.chunk_every(part2, 1, :discard)
  |> Enum.with_index()
  |> Enum.filter(fn { l, _ } ->
        Enum.uniq(l) == l
    end)
  |> hd()
  |> then(fn {_, i} -> part2 + i end)
  |> IO.inspect()
