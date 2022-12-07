defmodule Tree do
  # def parse_input(""), do
  def parse_input({id, parent_id, descr}) do
    # {0, 0, "/ (dir)"}
    type = if String.contains?(descr, "file"), do: :file, else: :dir

    size =
      if String.contains?(descr, "size="),
        do:
          String.replace(descr, ")", "")
          |> String.split("size=")
          |> Enum.at(-1)
          |> String.to_integer(),
        else: 0

    {id, parent_id, descr, type, size, []}
  end

  def parse_fs(list), do: parse_fs(list, [])
  def parse_fs([], acc), do: acc

  def parse_fs([{id, parent_id, descr, :file, size, children} | tail], acc) do
    # IO.inspect(descr, label: 'file')
    parse_fs(tail, [{id, parent_id, descr, :file, size, children} | acc])
  end

  def parse_fs([{id, parent_id, descr, :dir, _size, _children} = head | tail], acc) do
    # IO.inspect(descr, label: 'dir')
    dir = partition(head, tail)
    # IO.inspect(dir, label: 'dirs')
    new_acc = [{id, parent_id, descr, :dir, dir_size(dir), parse_fs(dir)} | acc]
    parse_fs(tail -- dir, new_acc)
  end

  def partition(dir, list) do
    worker = fn t1 ->
      fn t2 -> elem(t2, 0) > elem(t1, 0) end
    end

    list |> Enum.take_while(&worker.(dir).(&1))
  end

  def dir_size(dirlist), do: dir_size(dirlist, 0)
  def dir_size([], acc), do: acc
  def dir_size([{_, _, _, _, size, _} | tail], acc), do: dir_size(tail, size + acc)

  def get_dirs(list), do: get_dirs(list, [])
  def get_dirs([], acc), do: acc
  def get_dirs([{_, _, _, :file, _size, _children} | tail], acc), do: get_dirs(tail, acc)

  def get_dirs([{id, parent_id, descr, :dir, size, children} | tail], acc) do
    get_dirs(tail, [{id, parent_id, descr, :dir, size} | get_dirs(children, acc)])
  end
end

list =
  [
    {0, 0, "/ (dir)"},
    {2, 0, "a (dir)"},
    {4, 2, "e (dir)"},
    {6, 4, "i (file, size=584)"},
    {4, 2, "f (file, size=29116)"},
    {4, 2, "g (file, size=2557)"},
    {4, 2, "h.lst (file, size=62596)"},
    {2, 0, "b.txt (file, size=14848514)"},
    {2, 0, "c.dat (file, size=8504156)"},
    {2, 0, "d (dir)"},
    {4, 2, "j (file, size=4060174)"},
    {4, 2, "d.log (file, size=8033020)"},
    {4, 2, "d.ext (file, size=5626152)"},
    {4, 2, "k (file, size=7214296)"}
  ]
  |> Enum.map(&Tree.parse_input/1)

  Tree.parse_fs(list)
# |> Tree.get_dirs()
# # |> Enum.filter(fn {id, parent_id, descr, :dir, size} -> size < 100_000 end)
# |> Enum.reduce(0, fn {id, parent_id, descr, :dir, size}, acc ->
#   if size < 100_000, do: acc + size, else: acc
# end)
