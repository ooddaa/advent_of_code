defmodule Solution do 
 
   @dR [-1, -1, -1, 0, 1, 1, 1, 0]
   @dC [-1, 0, 1, 1, 1, 0, -1, -1]

   def parse_input(path \\ "input_test") do
    path 
    |> File.read!()
    |> String.split("\n", trim: true)
   end

   def build_grid(rows) do 
     for {line, row} <- Enum.with_index(rows),
          {letter, col} <- Enum.with_index(String.split(line, "", trim: true)), 
          into: %{}, 
      do: { {row, col}, letter }  
  end

  def find_letter(grid, letter) do
    Enum.filter(grid, &(elem(&1,1) == letter)) 
  end

  def get_new_pos({row, col}, {x, y}), do: {row + x, col + y}

  def get_neighbours_directions(pos, grid) do 
      neibs = for {i, j} <- Enum.zip(@dR, @dC), do: {i, j} 
      Enum.filter(neibs, &(Map.get(grid, get_new_pos(pos, &1)) != nil))
  end

   def walk({{row, col} = pos, _}, grid) do
      # look into adjacent cells for letter M    
      get_neighbours_directions(pos, grid)
      |> Enum.filter(&(Map.get(grid, get_new_pos(pos, &1)) == "M"))
      |> Enum.filter(fn dir -> 
          # at this point we already XM.. 
          # lookahead for the next A and S
          # because all paths are straight
          # lets check the next two letters in the same direction
          {x,y} = dir
          a_pos = get_new_pos({row, col}, {x*2, y*2})
          s_pos = get_new_pos({row, col}, {x*3, y*3})

          Map.get(grid, a_pos) == "A" &&
          Map.get(grid, s_pos) == "S"
          end)
      |> length()
   end
  
   def walk_2({pos, _}, grid) do
      dir = get_neighbours_directions(pos, grid)
      case length(dir) do 
        8 -> 
          box = Enum.map(dir, &(Map.get(grid, get_new_pos(pos, &1))))
          if has_xmas?(box), do: 1, else: 0 
        _ -> 0
      end
   end

   def has_xmas?(box) do
      case box do
        ["S", _, "S", _, "M", _, "M", _] -> true
        ["M", _, "S", _, "S", _, "M", _] -> true
        ["M", _, "M", _, "S", _, "S", _] -> true
        ["S", _, "M", _, "M", _, "S", _] -> true
        _ -> false
      end
   end
  
  # part 1
  def solve(input) do 
   grid =
    input
    |> parse_input()
    |> build_grid()
    grid
    |> find_letter("X")
    |> Enum.map(&(walk(&1, grid)))
    |> List.flatten() 
    |> Enum.sum()
  end

   # part2 
   def solve_2(input) do
     grid =
      input
      |> parse_input()
      |> build_grid()
     grid 
     |> find_letter("A")
     |> Enum.map(&(walk_2(&1, grid)))
     |> Enum.sum()
   end
end

# part 1
# "input"
# |> Solution.solve()
# |> IO.inspect()
# 2583

# part 2
# "input"
# |> Solution.solve_2()
# |> IO.inspect()
# 1978
