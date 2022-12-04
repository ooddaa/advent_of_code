numbers =
  File.read!("input")
  |> String.split("\n")
  |> Enum.map(&String.split(&1,",", trim: true)
    |> Enum.map(fn s -> String.split(s,"-", trim: true) |> Enum.map(fn s -> String.to_integer(s) end) end)
    )

# Part 1
numbers
|> Enum.filter(fn
    [[a,b], [c,d]] ->
      if (a >= c and b <= d) or (c >= a and d <= b), do: true, else: false
    _ -> false
  end)
  |> length()
  |> IO.inspect(label: 'part 1') # 532

# Part 2
numbers
|> Enum.filter(fn
    [[a,b], [c,d]] ->
      if (b >= c and a <= d) or (d >= a and c <= b), do: true, else: false
    _ -> false
  end)
  |> length()
  |> IO.inspect(label: 'part 2') # 854
