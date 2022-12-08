defmodule Fs do
  def parse_dir_descr(dir) do
    dir
    |> Enum.filter(&String.contains?(&1, "dir"))
  end

  def parse_dir_name(name) do
    name |> String.split("dir ") |> Enum.at(1)
  end

  def sum_up_files(files) do
    files
    |> Enum.map(&(String.split(&1, " ", trim: true) |> Enum.at(0) |> String.to_integer()))
    |> Enum.sum()
  end

  def parser(list), do: parser(list, [])
  def parser([], acc), do: acc
  def parser([[".."|_rest]|tail], acc), do: parser(tail, acc)
  def parser([[dir|rest] = head|tail], acc) do
    subdirs = Fs.parse_dir_descr(head)
    # IO.inspect(subdirs, label: 'subdirs')
    files = rest -- subdirs
    # IO.inspect(files, label: 'files')
    if length(subdirs) == 0 do
      # no subdirs, sum up files
      # ["d", 24933642]
      parser(tail, [[dir | [sum_up_files(files)]] | acc ])
    else
      parser(tail, [[dir | [sum_up_files(files) + 0]] | acc ])
    end
  end

  def deps(list) do
    list
    |> Enum.map(&Fs.parse_dir_descr(&1)
      |> Enum.map(fn name when is_bitstring(name) -> Fs.parse_dir_name(name) end))
  end

  def match_deps(list), do: match_deps(list, [])
  def match_deps([], acc), do: acc
  def match_deps([{ [subdir, size], dependencies} = head|tail], acc) do
    # {["d", 24933642], []}
    # [{["/", 23352670], ["a", "d"]}, {["a", 94269], ["e"]}, {["e", 584], []}, {["d", 24933642], []}]
    # go find first dir where subdir is a dependency and sub it with size
    index =
      tail
      |> Enum.find_index(fn {[_parent_name, _], deps} -> Enum.member?(deps, subdir) end)
    case index do
      nil ->
        # nothing to do
        match_deps(tail, [head | acc])
      i ->
        # need to swap subdir name for subdir size in parents deps
        { parent_head, deps } = Enum.at(tail, i)
        new_deps = Enum.map(deps, fn dep -> if dep == subdir, do: size + Enum.sum(dependencies), else: dep end)
        new_parent = { parent_head, new_deps }

        new_tail =
          tail
          |> List.replace_at(i, new_parent)
        match_deps(new_tail, [head|acc])
    end
  end
end

data =
  File.read!("input")
  |> String.split("$ cd ", trim: true)
  |> Enum.map(&String.split(&1, "\n", trim: true))
  |> Enum.map(&(&1 -- ["$ ls"]))

|> Enum.filter(fn
  [".."] -> false
  _ -> true
end)

totals =
  data
  |> Enum.reverse()
  |> Fs.parser()

deps = Fs.deps(data)
zips = Enum.zip(totals, deps)

zips
  |> Enum.reverse()
  |> Fs.match_deps()
  |> Enum.map(fn { [_dir, dsize], deps} -> dsize + Enum.sum(deps) end)
  |> Enum.filter(&(&1 < 100_000))
  |> Enum.sum()
  |> IO.inspect() # part 1 1118405
