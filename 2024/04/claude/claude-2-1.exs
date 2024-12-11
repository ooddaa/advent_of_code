defmodule WordSearch do
  @moduledoc"""
  PROMPT: what improvements can you suggest to this version: 
  """
  @target "XMAS"
  @target_length String.length(@target)
  @target_chars String.graphemes(@target)
  
  @directions [
    {0, 1},   # right
    {1, 0},   # down
    {1, 1},   # diagonal down-right
    {1, -1},  # diagonal down-left
    {0, -1},  # left
    {-1, 0},  # up
    {-1, 1},  # diagonal up-right
    {-1, -1}  # diagonal up-left
  ]

  def solve(input) when is_binary(input) do
    input
    |> parse_grid()
    |> count_occurrences()
  end

  defp parse_grid(input) do
    grid = input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    
    {grid, length(grid), length(hd(grid))}
  end

  defp count_occurrences({grid, rows, cols}) do
    for row <- 0..(rows-1),
        col <- 0..(cols-1),
        direction <- @directions,
        reduce: MapSet.new() do
      acc ->
        case find_word_at_position(grid, {row, col}, direction, rows, cols) do
          {:ok, position} -> MapSet.put(acc, position)
          :error -> acc
        end
    end
    |> MapSet.size()
  end

  defp find_word_at_position(grid, {row, col}, {dr, dc} = dir, rows, cols) do
    with true <- word_fits?({row, col}, dir, rows, cols),
         {:ok, word} <- get_word(grid, {row, col}, dir) do
      if word == @target_chars do
        {:ok, {row, col, dr, dc}}
      else
        :error
      end
    else
      _ -> :error
    end
  end

  defp word_fits?({row, col}, {dr, dc}, rows, cols) do
    end_row = row + (@target_length - 1) * dr
    end_col = col + (@target_length - 1) * dc
    
    end_row >= 0 and end_row < rows and
    end_col >= 0 and end_col < cols
  end

  defp get_word(grid, {row, col}, {dr, dc}) do
    try do
      word = for i <- 0..(@target_length-1) do
        grid
        |> Enum.at(row + i * dr)
        |> Enum.at(col + i * dc)
      end
      {:ok, word}
    rescue
      _ -> :error
    end
  end

  # Optional: Add debugging helper to visualize found matches
  def visualize(input) do
    grid = input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    
    {grid, rows, cols} = {grid, length(grid), length(hd(grid))}
    matches = for row <- 0..(rows-1),
                col <- 0..(cols-1),
                direction <- @directions,
                match = find_word_at_position(grid, {row, col}, direction, rows, cols),
                match != :error,
                do: match
    
    # Create a map of positions that are part of XMAS occurrences
    used_positions = matches
    |> Enum.reduce(MapSet.new(), fn {:ok, {row, col, dr, dc}}, acc ->
      Enum.reduce(0..(@target_length-1), acc, fn i, inner_acc ->
        MapSet.put(inner_acc, {row + i * dr, col + i * dc})
      end)
    end)

    # Print the grid with dots for unused positions
    grid
    |> Enum.with_index()
    |> Enum.map(fn {row, row_idx} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {char, col_idx} ->
        if MapSet.member?(used_positions, {row_idx, col_idx}), do: char, else: "."
      end)
      |> Enum.join()
    end)
    |> Enum.join("\n")
  end
end
