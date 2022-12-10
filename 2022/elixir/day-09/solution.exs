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

  defmodule Snake do
    def tail_route list, opt \\ [] do
      log? = case Keyword.fetch(opt, :log) do
        {:ok, true} -> true
        _ -> false
      end

      list
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.reduce([{0,0}], fn
        [{head_last_r, head_last_c}, {head_cur_r, head_cur_c}], acc ->

          [{tail_last_r, tail_last_c}|_] = Enum.reverse(acc)
          # if head went too far (>1 steps) copy last head position,
          # if not, stay where you are
          tail_cur = if abs(head_cur_r - tail_last_r) > 1 or abs(head_cur_c - tail_last_c) > 1 do

            # was it a diagonal movement?
            diagonal? = head_last_r != head_cur_r and head_last_c != head_cur_c
            if diagonal? do
              # what kind of diagonal? needs to be relative to initial position

              # first case ✅          🚫 not too far/diagonal
              # .ht..  ..t..  .....   .ht.. ..t.. .....   ..... ..... .....
              # .....  h....  ht...   ..... ..h.. .....   ..... ..... .....
              # .....  .....  .....   ..... ..... .....   ..... ..... .....
              # .....  .....  .....   ..... ..... .....   ..... ..... .....

              # second case                                                    non-aligned
              # .....  .....  .....   ..... ..... .....   .h... ..... .....   .....  .....  .....
              # .t...  .t...  .....   ..t.. ..t.. .....   t.... t.h.. .th..   .....  h....  h....
              # h....  .....  .t...   ...h. ..... ..t..   ..... ..... .....   .h...  .....  .t...
              # .....  .h...  .h...   ..... ..h.. ..h..   ..... ..... .....   ..t..  ..t..  .....

              d_r = if head_cur_r == tail_last_r, do: 0, else: head_cur_r - head_last_r
              d_c = if head_cur_c == tail_last_c, do: 0, else: head_cur_c - head_last_c
              {tail_last_r + d_r, tail_last_c + d_c}

            else
              {head_last_r, head_last_c}
            end
          else
            {tail_last_r, tail_last_c}
          end
          if log?, do: IO.inspect({chunk, [t_chunk, tail_cur] })
          acc ++ [tail_cur]
      end)
    end
  end


# part1
# head_route
# |> Enum.chunk_every(2, 1, :discard)
# |> Enum.reduce([{0, 0}], fn [last_head_pos, {head_cur_r, head_cur_c}], acc ->
#   [{tail_last_r, tail_last_c} | _] = Enum.reverse(acc)
#   # if either abs(h_r - t) or abs(h_c - t) > 1 copy last head position, if not, stay where you are
#   tail_cur =
#     if abs(head_cur_r - tail_last_r) > 1 or abs(head_cur_c - tail_last_c) > 1 do
#       last_head_pos
#     else
#       {tail_last_r, tail_last_c}
#     end
#   acc ++ [tail_cur]
# end)
# |> Enum.uniq()
# |> length()
# |> IO.inspect() # 6081

mark = fn
  {row, col}, board, marker ->
    put_in(board, [Access.at((row + 10)), Access.at((col + 20))], marker)
  end

board = "." |> List.duplicate(80) |> List.duplicate(60)

part2 =
  head_route
  |> Snake.tail_route()
  |> Snake.tail_route()
  |> Snake.tail_route()
  |> Snake.tail_route()
  |> Snake.tail_route()
  |> Snake.tail_route()
  |> Snake.tail_route()
  |> Snake.tail_route()
  |> Snake.tail_route()
  # |> Snake.tail_route(log: true)
  |> Enum.uniq()

  # Visualize this fukkery
  # |> Enum.reduce(board, fn pos, acc -> mark.(pos, acc, "*") end)
  # |> Enum.map(&Enum.join(&1, ""))

  #
  |> length()
  # |> IO.inspect() # 2487
