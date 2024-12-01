defmodule LocationAnalysis do
  @doc """
  Parses input string into two lists of numbers.
  """
  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
    |> Enum.unzip()
  end

  @doc """
  Calculates total distance between sorted lists for Part 1.
  """
  def calculate_distance(left, right) do
    Enum.zip(Enum.sort(left), Enum.sort(right))
    |> Enum.map(fn {l, r} -> abs(l - r) end)
    |> Enum.sum()
  end

  @doc """
  Calculates similarity score based on frequency matching for Part 2.
  """
  def calculate_similarity_score(left, right) do
    # Count frequencies in right list
    frequencies = Enum.frequencies(right)
    
    # For each number in left list, multiply by its frequency in right list
    left
    |> Enum.map(fn num -> num * Map.get(frequencies, num, 0) end)
    |> Enum.sum()
  end

  @doc """
  Solves both parts of the puzzle for given input.
  """
  def solve(input) do
    {left, right} = parse_input(input)
    
    part1 = calculate_distance(left, right)
    part2 = calculate_similarity_score(left, right)
    
    {part1, part2}
  end
end

# Example usage
# example_input = """
# 3   4
# 4   3
# 2   5
# 1   3
# 3   9
# 3   3
# """

# example_input = File.read!("input")

{part1, part2} = LocationAnalysis.solve(example_input)
IO.puts("Part 1 - Total distance: #{part1}")      # Should be 11
IO.puts("Part 2 - Similarity score: #{part2}")    # Should be 31
