defmodule WordSearch do
  @target_word "XMAS"
  @directions [
    {0, 1},   # right
    {1, 0},   # down
    {1, 1},   # diagonal down-right
    {-1, 1},  # diagonal up-right
    {0, -1},  # left
    {-1, 0},  # up
    {-1, -1}, # diagonal up-left
    {1, -1}   # diagonal down-left
  ]

  def solve(input) do
    grid = parse_input(input)
    height = length(grid)
    width = length(hd(grid))
    
    for row <- 0..(height-1),
        col <- 0..(width-1),
        direction <- @directions,
        word_at_position?(grid, row, col, direction),
        reduce: 0 do
      acc -> acc + 1
    end
  end

  defp parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
  end

  defp word_at_position?(grid, row, col, {dy, dx}) do
    word_length = String.length(@target_word)
    height = length(grid)
    width = length(hd(grid))

    # Check if word would go out of bounds
    end_row = row + (dy * (word_length - 1))
    end_col = col + (dx * (word_length - 1))
    
    if end_row >= 0 and end_row < height and end_col >= 0 and end_col < width do
      # Get the characters in this direction
      word = for i <- 0..(word_length-1) do
        row_pos = row + (dy * i)
        col_pos = col + (dx * i)
        grid |> Enum.at(row_pos) |> Enum.at(col_pos)
      end
      |> Enum.join()

      word == @target_word
    else
      false
    end
  end

  def mark_matches(input) do
    grid = parse_input(input)
    height = length(grid)
    width = length(hd(grid))
    
    # Create a set of positions that are part of a match
    matching_positions = for row <- 0..(height-1),
        col <- 0..(width-1),
        direction <- @directions,
        word_at_position?(grid, row, col, direction) do
      word_length = String.length(@target_word)
      for i <- 0..(word_length-1) do
        {row + (elem(direction, 0) * i), col + (elem(direction, 1) * i)}
      end
    end
    |> List.flatten()
    |> MapSet.new()

    # Create the output grid with dots for non-matching positions
    for row <- 0..(height-1) do
      for col <- 0..(width-1) do
        if MapSet.member?(matching_positions, {row, col}) do
          grid |> Enum.at(row) |> Enum.at(col)
        else
          "."
        end
      end
      |> Enum.join()
    end
    |> Enum.join("\n")
  end
end

# Example usage:
input = """
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
"""

input =   
  "input"
  |> File.read!()

count = WordSearch.solve(input)
IO.puts("Found #{count} instances of XMAS")

marked_grid = WordSearch.mark_matches(input)
IO.puts("\nGrid with matches marked:")
IO.puts(marked_grid)
