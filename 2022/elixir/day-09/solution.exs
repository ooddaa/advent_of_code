instructions =
  File.read!("input")
  |> String.split("\n")
  |> Enum.map(&String.split(&1, " "))
  |> Enum.map(fn [l, n] -> [l, String.to_integer(n)] end)

head_route =
  instructions
  |> Enum.reduce([{0, 0}], fn [dir, steps], acc ->
    [{last_row, last_col} | _] = Enum.reverse(acc)

    movement =
      case dir do
        "R" ->
          for i <- (last_col + 1)..(last_col + steps),
              do: {last_row, i}

        "L" ->
          # decrease {row,col} col count
          for i <- (last_col - 1)..(last_col - steps),
              do: {last_row, i}

        "U" ->
          # decrease {row,col} row count
          for i <- (last_row - 1)..(last_row - steps),
              do: {i, last_col}

        "D" ->
          # increase {row,col} row count
          for i <- (last_row + 1)..(last_row + steps),
              do: {i, last_col}
      end

    acc ++ movement
  end)

head_route
|> Enum.chunk_every(2, 1, :discard)
|> Enum.reduce([{0, 0}], fn [last_head_pos, {head_cur_r, head_cur_c}], acc ->
  [{tail_last_r, tail_last_c} | _] = Enum.reverse(acc)
  # if either abs(h_r - t) or abs(h_c - t) > 1 copy last head position, if not, stay where you are
  tail_cur =
    if abs(head_cur_r - tail_last_r) > 1 or abs(head_cur_c - tail_last_c) > 1 do
      last_head_pos
    else
      {tail_last_r, tail_last_c}
    end
  acc ++ [tail_cur]
end)

|> Enum.uniq()
|> length()
# |> IO.inspect()
