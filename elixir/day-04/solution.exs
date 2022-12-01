numbers =
  "./numbers"
  |> File.stream!()
  # ["87,12,53,23,31,70,37,79,95,16,72,9,98,92,5,74,17,60,96,80,75,11,73,33,3,84,81,2,97,93,59,13,77,52,69,83,51,64,48,82,7,49,20,8,36,66,19,0,99,41,91,78,42,40,62,63,57,39,55,47,29,50,58,34,27,43,30,35,22,28,4,14,26,32,10,88,46,65,90,76,38,6,71,67,44,68,86,25,21,24,56,94,18,89,61,15,1,45,54,85"]
  |> Stream.map(&String.split(&1, ","))
  |> Enum.map(&Enum.map(&1, fn s -> String.to_integer(s) end))
  |> Enum.at(0)
  # |> IO.inspect()
  # [87, 12, 53, 23, 31, 70, 37, 79, 95, 16, 72, 9, 98, 92, 5, 74, 17, 60, 96, 80,
  # 75, 11, 73, 33, 3, 84, 81, 2, 97, 93, 59, 13, 77, 52, 69, 83, 51, 64, 48, 82,
  # 7, 49, 20, 8, 36, 66, 19, 0, 99, 41, ...]

boards =
  "./boards"
  |> File.stream!()
  |> Stream.map(&String.replace(&1, "\n", ""))
  |> Stream.map(&String.split(&1, " "))
  |> Stream.map(&Enum.filter(&1, fn s -> s != "" end))
  |> Stream.map(&Enum.map(&1, fn s -> String.to_integer(s) end))
  |> Stream.chunk_every(5,6)
  |> Enum.map(&(&1))
  # |> IO.inspect()

  # [
  #   [
  #     [49, 0, 9, 90, 8],
  #     [41, 88, 56, 13, 6],
  #     [17, 11, 45, 26, 75],
  #     [29, 62, 27, 83, 36],
  #     [31, 78, 1, 55, 38]
  #   ],

  defmodule Bingo do
    def mark_number_on_board(board, num) do
      Enum.map(board, fn
        row ->
          case Enum.find_index(row, &(&1 == num)) do
            nil -> row
            i -> List.replace_at(row, i, nil)
          end
        end)
    end

    def is_winner_row?([nil, nil, nil, nil, nil]) do
      true
    end
    def is_winner_row?(_) do
      false
    end

    def rotate_90(board) do
      board
      |> Stream.zip()
      |> Enum.map(&Tuple.to_list/1)
    end

    defp reducer(row, _acc) do
      if is_winner_row?(row), do: {:halt, true}, else: {:cont, false}
    end

    def is_winner?(board) do
      row_winner =
        board
        |> Enum.reduce_while(false, &reducer/2)

      col_winner =
        rotate_90(board)
        |> Enum.reduce_while(false, &reducer/2)

      if (row_winner or col_winner), do: {:winner, board}, else: {:loser, board}
    end

    def find_winner(boards) do
      rv =
        boards
        |> Stream.map(&is_winner?/1)
        |> Enum.filter(fn
          {:winner, board} -> true
          _ -> false
        end)
      case rv do
        [{:winner, board}] -> board
        _ -> nil
      end
    end

    def solution([num], boards) do
      IO.inspect("LAST!")

    end

    def solution([num|rest], boards) do
      new_boards =
        boards
        |> Enum.map(&(mark_number_on_board(&1, num)))
        # |> IO.inspect()

      case find_winner(new_boards) do
        nil -> solution(rest, new_boards)
        board -> calculate_answer(num, board)
      end

    end

    def calculate_answer(num, board) do
      board
      |> Enum.reduce([], fn row, acc -> acc ++ row end) # flatten
      |> Enum.filter(&(&1 != nil))
      |> Enum.sum()
      |> then(&(&1 * num))
      # |> IO.inspect()
    end
  end

Bingo.solution(numbers, boards)
|> IO.inspect()

# 2745
