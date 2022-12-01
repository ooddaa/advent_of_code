#  4245351
numbers =
  # input
  # |> Kino.Input.read()
  File.read!("day-03_input")
  |> String.split("\n")
  |> Enum.map(&String.split(&1, "", trim: true)
    |> Enum.map(fn s -> String.to_integer(s) end)
    )

common_bit =
  fn
    enum when is_tuple(enum)->
      {Enum.sum(Tuple.to_list(enum)), tuple_size(enum)/2}
    enum when is_list(enum)->
      {Enum.sum(enum), length(enum)/2}
  end

most_common_val =
  fn enum ->
    {bit, half} = common_bit.(enum)
    bit >= half && 1 || 0
  end

least_common_val =
  fn enum ->
    {bit, half} = common_bit.(enum)
    bit < half && 1 || 0
  end

range = numbers |> Enum.at(0) |> length

reducer =
  fn predicate ->
    fn bit, {numbers, bits} ->
    val =
      numbers |> Enum.zip() |> List.to_tuple() |> elem(bit)
      |> predicate.()

    new_numbers =
      numbers
      |> Enum.filter(fn row ->
        row |> Enum.at(bit) == val
      end)

    if length(new_numbers) == 1 do
      {:halt, { new_numbers |> Enum.at(0), [val | bits] |> Enum.reverse() } }
    else
      {:cont, { new_numbers, [val | bits] |> Enum.reverse() } }
    end
  end
end
oxygen =
  0..range
  |> Enum.reduce_while({ numbers, []}, reducer.(most_common_val))

co2 =
  0..range
  |> Enum.reduce_while({ numbers, []}, reducer.(least_common_val))

{ ox_num, _ } =
  oxygen
  |> elem(0)
|> Enum.join("")
|> Integer.parse(2)

{ co2_num, _ } =
  co2
  |> elem(0)
|> Enum.join("")
|> Integer.parse(2)
ox_num * co2_num
# |> IO.inspect() #4245351
