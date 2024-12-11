defmodule WordSearch do
  @moduledoc"""
  Solves a word search puzzle by finding all occurrences of a target word in any direction.
  Supports horizontal, vertical, and diagonal searches in both directions.

  PROMPT: what improvements can you suggest for this solution? 
  think step-by-step, take the perspective of the reader.

    Let me analyze this code step by step from a reader's perspective and suggest improvements to enhance its clarity, maintainability, and performance.
    Improved Word Search Solution
    Key improvements made:

    Documentation and Clarity:

    Added @moduledoc and @doc documentation
    Named directions in a map for better readability
    Broke down large functions into smaller, well-named ones
    Used better variable names (e.g., dimensions instead of separate height/width)


    Code Structure:

    Grouped related functionality together
    Used with expressions for better flow control
    Added input validation with guard clauses
    Separated grid parsing and dimension calculation


    Performance Optimizations:

    Precomputed target word length
    Used pattern matching for coordinate tuples
    Reduced redundant calculations


    Error Handling and Safety:

    Added input validation
    Used guard clauses to ensure input types
    Better boundary checking



    Example usage:
    elixirCopyinput = \"""
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
    \"""

    # Find matches
    count = WordSearch.solve(input)
    IO.puts("Found #{count} instances of XMAS")

    # Visualize matches
    IO.puts("\nGrid with matches marked:")
    IO.puts(WordSearch.mark_matches(input))
  """

  @target_word "XMAS"
  @target_length String.length(@target_word)

  # Each direction is documented with its meaning for clarity
  @directions %{
    right:           {0, 1},
    down:            {1, 0},
    diagonal_down_r: {1, 1},
    diagonal_up_r:   {-1, 1},
    left:            {0, -1},
    up:              {-1, 0},
    diagonal_up_l:   {-1, -1},
    diagonal_down_l: {1, -1}
  }

  @doc """
  Counts all occurrences of #{@target_word} in the input grid.
  Returns the total count of matches found.
  """
  def solve(input) when is_binary(input) do
    with {grid, dimensions} <- parse_and_validate_input(input) do
      count_matches(grid, dimensions)
    end
  end

  @doc """
  Returns a string representation of the grid where non-matching positions
  are replaced with dots (.) and matching positions show the original characters.
  """
  def mark_matches(input) when is_binary(input) do
    with {grid, {height, width}} <- parse_and_validate_input(input) do
      matching_positions = find_matching_positions(grid, {height, width})
      
      build_marked_grid(grid, matching_positions, {height, width})
    end
  end

  # Private functions with clear, descriptive names

  defp parse_and_validate_input(input) do
    grid = input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)

    dimensions = {length(grid), length(hd(grid))}
    {grid, dimensions}
  end

  defp count_matches(grid, {height, width}) do
    for row <- 0..(height-1),
        col <- 0..(width-1),
        {_direction, vector} <- @directions,
        matches_at_position?(grid, {row, col}, vector, {height, width}),
        reduce: 0 do
      count -> count + 1
    end
  end

  defp matches_at_position?(grid, {row, col}, {dy, dx}, dimensions) do
    with true <- position_in_bounds?({row, col}, {dy, dx}, dimensions),
         word <- extract_word(grid, {row, col}, {dy, dx}) do
      word == @target_word
    else
      false -> false
    end
  end

  defp position_in_bounds?({row, col}, {dy, dx}, {height, width}) do
    end_row = row + (dy * (@target_length - 1))
    end_col = col + (dx * (@target_length - 1))
    
    end_row >= 0 and end_row < height and 
    end_col >= 0 and end_col < width
  end

  defp extract_word(grid, {row, col}, {dy, dx}) do
    0..(@target_length-1)
    |> Enum.map(fn i ->
      row_pos = row + (dy * i)
      col_pos = col + (dx * i)
      grid |> Enum.at(row_pos) |> Enum.at(col_pos)
    end)
    |> Enum.join()
  end

  defp find_matching_positions(grid, {height, width}) do
    for row <- 0..(height-1),
        col <- 0..(width-1),
        {_direction, vector} <- @directions,
        matches_at_position?(grid, {row, col}, vector, {height, width}) do
      get_word_positions({row, col}, vector)
    end
    |> List.flatten()
    |> MapSet.new()
  end

  defp get_word_positions({row, col}, {dy, dx}) do
    0..(@target_length-1)
    |> Enum.map(fn i ->
      {row + (dy * i), col + (dx * i)}
    end)
  end

  defp build_marked_grid(grid, matching_positions, {height, width}) do
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
