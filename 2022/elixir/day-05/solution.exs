[crates, instructions] =
  File.read!("input")
  |> String.split("\n\n")


crates =
  crates
  |> String.split("", trim: true)
  |> Enum.chunk_every(3, 4)
  |> Enum.map(fn [_, letter, _] -> letter end)
  |> Enum.chunk_every(9)
  |> Enum.slice(0..7)
  |> Enum.zip()
  |> Enum.map(&(
    Tuple.to_list(&1) |>
    Enum.filter(fn crate -> crate != " " end)))
  |> Enum.with_index(1)
  |> Map.new(fn {v,k} -> {k,v} end)

instructions =
  instructions
  |> String.split("\n", trim: true)
  |> Enum.map(&String.split(&1," ", trim: true))

  defmodule Crane do
    def move(crates, instruction) do
      {num, col1, col2} = parse_instruction(instruction)

      moved = Enum.take(crates[col1], num)

      crates
      |> Map.put(col1, crates[col1] -- moved)
      # |> Map.put(col2, Enum.reverse(moved) ++ crates[col2]) # Part 1 CWMTGHBDW
      |> Map.put(col2, moved ++ crates[col2]) # Part 2 SSCGWJCRB
    end

    defp parse_instruction(["move", num, "from", col1, "to", col2]) do
      { String.to_integer(num), String.to_integer(col1), String.to_integer(col2)}
    end
  end

instructions
  |> Enum.reduce(crates, fn instr, acc -> Crane.move(acc, instr) end)
  |> Enum.map(fn {_, [head|_]} -> head end)
  |> Enum.join("")
  |> IO.inspect()
