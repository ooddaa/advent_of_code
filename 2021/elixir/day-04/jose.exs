[numbers | grids] =
  File.read!("./input")
  |> String.split("\n", trim: true)

boards =
  grids
  |> Enum.chunk_every(5)
  |> Enum.map(fn rows ->
    Board.new(
      for {line, row} <- Enum.with_index(rows), # [{term(), integer()}]
          {number, col} <- Enum.with_index(String.split(line)),
          into: %{} do
            {String.to_integer(number), {row, col}}
          end
    )
  end)
  |> IO.inspect()

# {number, board = %Board{}} =
#   numbers
#   |> String.split(",", trim: true)
#   |> Enum.map(&String.to_integer/1)
#   |> Enum.reduce_while(boards, fn number, boards ->
#     boards = Enum.map(boards, &Board.mark(&1, number))
#     if board = Enum.find(boards, &Board.won?/1) do
#       {:halt, {number, board}}
#     else
#       {:cont, boards}
#     end
#   end)

# number * Board.unmarked_sum(board)
# |> IO.inspect()
