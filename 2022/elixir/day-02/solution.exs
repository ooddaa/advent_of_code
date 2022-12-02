numbers =
  File.read!("input")
  |> String.split("\n")
  |> Enum.map(
    &(String.split(&1, " ", trim: true)
      # |> Enum.map(fn s -> String.to_integer(s) end)
      )
  )

defmodule RPS do
  # 1 A X Rock
  # 2 B Y Paper
  # 3 C Z Scissors

  # 6 win
  # 3 draw
  # 0 lose
  # choice + result
  def match(["A", "X"]), do: 1 + 3
  def match(["B", "X"]), do: 1 + 0
  def match(["C", "X"]), do: 1 + 6

  def match(["A", "Y"]), do: 2 + 6
  def match(["B", "Y"]), do: 2 + 3
  def match(["C", "Y"]), do: 2 + 0

  def match(["A", "Z"]), do: 3 + 0
  def match(["B", "Z"]), do: 3 + 6
  def match(["C", "Z"]), do: 3 + 3

  def n("A"), do: 1
  def n("B"), do: 2
  def n("C"), do: 3

  # 0 X lose
  # 3 Y draw
  # 6 Z win
  def match2([item, "X"]), do: lose(item) + 0
  def match2([item, "Y"]), do: draw(item) + 3
  def match2([item, "Z"]), do: win(item) + 6

  def lose("A"), do: 3
  def lose("B"), do: 1
  def lose("C"), do: 2

  def draw("A"), do: 1
  def draw("B"), do: 2
  def draw("C"), do: 3

  def win("A"), do: 2
  def win("B"), do: 3
  def win("C"), do: 1


  # solution 2
  # we just need to make a -1 0 +1 sttps to lose draw or win respectively
  def match3([item, "X"]), do: lose1(item) + 0
  def match3([item, "Y"]), do: draw1(item) + 3
  def match3([item, "Z"]), do: win1(item) + 6

  def mod3(val), do: if rem(3,val) < 3, do: val, else: val - 3

  # to win we need a +1 choice (mod 3)
  def win1(item) do
    n(item) + 1 |> mod3()
  end

  # to lose we need a -1 choice (mod 3)
  # def lose1(a,b) do
  #   diff = a - b
  #   if diff <= 0, do: diff + 3, else: diff
  # end
  def lose1(item) do
    # val = n(item) - 1
    # if val == 0, do: 3, else: mod3(val)
    n(item) - 1
    |> case do
      0 -> 3
      val -> mod3(val)
    end
  end

  def draw1(item), do: n(item)
end


# part 1 17189
numbers
|> Enum.map(&RPS.match/1)
|> Enum.sum()
|> IO.inspect()

# part 2 13490
numbers
|> Enum.map(&RPS.match2/1)
|> Enum.sum()
