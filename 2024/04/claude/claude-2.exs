defmodule WordSearch do
  @target "XMAS"

  def count_occurrences(input) do
    # Convert input string to grid of characters
    grid = input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)

    rows = length(grid)
    cols = length(hd(grid))

    # Check all possible starting positions
    for row <- 0..(rows-1),
        col <- 0..(cols-1),
        direction <- get_directions(),
        has_word?(grid, row, col, direction),
        reduce: 0 do
      acc -> acc + 1
    end
  end

  defp get_directions do
    [
      {0, 1},   # right
      {1, 0},   # down
      {1, 1},   # diagonal down-right
      {1, -1},  # diagonal down-left
      {0, -1},  # left
      {-1, 0},  # up
      {-1, 1},  # diagonal up-right
      {-1, -1}  # diagonal up-left
    ]
  end

  defp has_word?(grid, start_row, start_col, {dr, dc}) do
    rows = length(grid)
    cols = length(hd(grid))
    
    # Check if the word would fit in this direction
    if word_fits?(start_row, start_col, dr, dc, String.length(@target), rows, cols) do
      # Get the characters in this direction
      word = get_word(grid, start_row, start_col, dr, dc, String.length(@target))
      word == String.graphemes(@target)
    else
      false
    end
  end

  defp word_fits?(row, col, dr, dc, len, rows, cols) do
    end_row = row + (len - 1) * dr
    end_col = col + (len - 1) * dc
    
    end_row >= 0 and end_row < rows and
    end_col >= 0 and end_col < cols
  end

  defp get_word(grid, row, col, dr, dc, len) do
    for i <- 0..(len-1) do
      grid
      |> Enum.at(row + i * dr)
      |> Enum.at(col + i * dc)
    end
  end

  def solve(input) do
    input
    |> String.trim()
    |> count_occurrences()
  end
end
