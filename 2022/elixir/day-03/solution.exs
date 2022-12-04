calc_letter_score = fn
  set ->
    set
    |> MapSet.to_list()
    |> Enum.at(0)
    |> String.normalize(:nfc)
    |> String.to_charlist()
    |> hd()
    |> then(fn cp ->
      if cp < 97, do: cp - 38, else: cp - 96
    end)
end

letters =
  File.read!("input")
  |> String.split("\n")
  |> Enum.map(&String.split(&1,"", trim: true))

# Part 1
letters
  |> Enum.map(&(Enum.chunk_every(&1, div(length(&1), 2)))) # chunk in halves
  |> Enum.map(fn [a,b] ->
    MapSet.intersection(MapSet.new(a), MapSet.new(b))
    |> calc_letter_score.()
  end)
  |> Enum.sum()
  |> IO.inspect() # 8123


# Part 2
letters
  |> Enum.chunk_every(3)
  |> Enum.map(fn [a,b,c] ->
    MapSet.intersection(MapSet.new(a), MapSet.new(b))
    |> MapSet.intersection(MapSet.new(c))
    |> calc_letter_score.()
  end)
  |> Enum.sum()
  |> IO.inspect() # 2620
