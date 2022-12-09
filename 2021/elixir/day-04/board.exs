defmodule Board do
  empty_grid = Tuple.duplicate(Tuple.duplicate(false, 5), 5)
  @enforce_keys [:numbers]
  defstruct numbers: %{}, grid: empty_grid

  def new(numbers) when is_map(numbers) do
    %Board{numbers: numbers}
    # |> IO.inspect()
  end

  # %Board{
  #   numbers: %{
  #     3 => {4, 3},
  #     5 => {3, 0},
  #     8 => {2, 0},
  #     10 => {4, 0},
  #     13 => {3, 1},
  #     20 => {1, 0},
  #     22 => {1, 4},
  #     24 => {0, 2},
  #     25 => {0, 0},
  #     30 => {3, 2},
  #     31 => {3, 3},
  #     37 => {0, 1},
  #     40 => {1, 3},
  #     46 => {3, 4},
  #     47 => {1, 2},
  #     48 => {1, 1},
  #     55 => {2, 1},
  #     64 => {2, 3},
  #     65 => {4, 1},
  #     66 => {4, 4},
  #     68 => {4, 2},
  #     70 => {2, 4},
  #     76 => {0, 3},
  #     93 => {2, 2},
  #     98 => {0, 4}
  #   },
  #   grid: {{false, false, false, false, false},
  #    {false, false, false, false, false}, {false, false, false, false, false},
  #    {false, false, false, false, false}, {false, false, false, false, false}}
  # },

  def mark(%Board{numbers: numbers} = board, number) do
    case numbers do
      %{^number => {row, col}} ->
        # https://hexdocs.pm/elixir/Kernel.html#put_in/3
          put_in(board, [Access.key(:grid), Access.elem(row), Access.elem(col)], true)
      _ -> board
    end
  end

  def unmarked_sum(%Board{numbers: numbers, grid: grid}) do
    Enum.sum(
      for {number, {row, col}} <- numbers,
      grid |> elem(row) |> elem(col) == false,
      do: number
    )
  end

  def won?(%Board{grid: grid}) do
    row_won?(grid) or col_won?(grid)
  end

  defp row_won?(grid) do
    Enum.any?(0..4, fn row->
      elem(grid, row) == {true, true, true, true, true}
    end)
  end

  defp col_won?(grid) do
   Enum.any?(0..4, fn col ->
     Enum.all?(0..4, fn row ->
      grid |> elem(row) |> elem(col) == true
     end)
   end)
  end
end
