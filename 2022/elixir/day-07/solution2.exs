defmodule Fs do
  def create_fs(input) do
    # "$ cd /\n$ ls\ndir a\n14848514 b.txt\n8504156 blalbla
    input
    |> String.split("$ cd ", trim: true)
    |> Enum.map(&String.split(&1, "\n", trim: true))
    |> Enum.map(&(&1 -- ["$ ls"]))
    # [{dirname, abs_path}, rest ]
    |> Enum.map(fn [dirname | rest] -> [{dirname, ""} | parse_files_subdirs(rest)] end)
  end

  def parse_files_subdirs(list) do
    # ["dir a", "14848514 b.txt", "8504156 c.dat", "dir d"]
    subdirs =
      list
      |> Enum.filter(&String.contains?(&1, "dir"))
      |> Enum.map(&(String.split(&1, "dir ") |> Enum.at(1)))

    files =
      list
      |> Enum.filter(&(not String.contains?(&1, "dir")))

    # [["a", "d"], ["14848514 b.txt", "8504156 c.dat"]]
    [subdirs, files]
  end

  def parse_file_descr(file) do
    [size, filename] =
      file
      |> String.split(" ", trim: true)

    {filename, String.to_integer(size)}
  end

  def go_up_one_folder(path) do
    path
    |> String.split("/")
    |> Enum.slice(0..-2)
    |> Enum.join("/")
  end

  def add_abs_path(list), do: add_abs_path(list, "", [])
  def add_abs_path([], _, acc), do: acc
  # def add_abs_path([head|tail], {"/", nil, nil}, acc) do

  # end
  def add_abs_path([[{dir, _path}, subdirs, files] | tail], pwd, acc) do
    # [
    #   [{"/", ""}, ["a", "d"], ["14848514 b.txt", "8504156 c.dat"]],
    #   [{"a", ""}, ["e"], ["29116 f", "2557 g", "62596 h.lst"]],
    #   [{"e", ""}, [], ["584 i"]],
    #   [{"..", ""}, [], []],
    #   [{"..", ""}, [], []],
    #   [{"d", ""}, [], ["4060174 j", "8033020 d.log", "5626152 d.ext", "7214296 k"]]
    # ]

    # [
    #   [{"/", "/"}, "$ ls", "dir a", "14848514 b.txt", "8504156 c.dat", "dir d"],
    #   [{"a", "/a"}, "$ ls", "dir e", "29116 f", "2557 g", "62596 h.lst"],
    #   [{"e", "/a/e"}, "$ ls", "584 i"],
    #   [{"..", "/a"}],
    #   [{"..", "/"}],
    #   [{"d", "/d"}, "$ ls", "4060174 j", "8033020 d.log", "5626152 d.ext", "7214296 k"]
    # ]

    new_path =
      if dir == ".." do
        go_up_one_folder(pwd)
      else
        if pwd == "/" or dir == "/", do: pwd <> dir, else: pwd <> "/" <> dir
      end

    add_abs_path(tail, new_path, [[{dir, new_path}, subdirs, files] | acc])
  end

  def get_all_files(list), do: Enum.flat_map(get_all_files(list, []), fn x -> x end)
  def get_all_files([], acc), do: acc

  def get_all_files([[{dir, path}, subdirs, files] | tail], acc) do
    rv =
      files
      |> Enum.map(fn file ->
        {filename, size} = parse_file_descr(file)
        {path, filename, size}
      end)

    get_all_files(tail, [rv | acc])
  end

  def get_new_dir_name(dir, name) do
    if dir == "/", do: dir <> name, else: dir <> "/" <> name
  end

  def group_files_by_dir(list) do
    list
    |> Enum.group_by(
      fn {dir, _, _} -> dir end,
      fn {dir, name, size} -> {get_new_dir_name(dir, name), size} end
    )
  end

  def calc_dir_sizes(list) do
    #     [
    #   {"/", "b.txt", 14848514},
    #   {"/", "c.dat", 8504156},
    #   {"/a", "f", 29116},
    #   {"/a", "g", 2557},
    #   {"/a", "h.lst", 62596},
    #   {"/a/e", "i", 584},
    #   {"/d", "j", 4060174},
    #   {"/d", "d.log", 8033020},
    #   {"/d", "d.ext", 5626152},
    #   {"/d", "k", 7214296}
    # ]

    # rv = [
    #   "/", (14848514 + 8504156 + 29116) = 23381786, ["/b.txt", "/c.dat", "/a/f", 'etc'],
    #   "/a", (29116 + 2557 + 62596 + 584) = 94853,  ["/a/f", "/a/g", "/a/h.lst", "/a/e/i"],
    # ]
    group_files_by_dir(list)
    |> add_subdirs()
    # |> IO.inspect()
    |> Enum.map(fn {dir, files} ->
      {dir,
       files
       |> Enum.reduce({[], 0}, fn {name, size}, {names, count} ->
         {[name | names], count + size}
       end)}
    end)
  end

  def add_subdirs(list) do
    # %{
    #   "/" => [{"/b.txt", 14848514}, {"/c.dat", 8504156}],
    #   "/a" => [{"/a/f", 29116}, {"/a/g", 2557}, {"/a/h.lst", 62596}],
    #   "/a/e" => [{"/a/e/i", 584}],
    #   "/d" => [{"/d/j", 4060174}, {"/d/d.log", 8033020}, {"/d/d.ext", 5626152}, {"/d/k", 7214296}]
    # }

    # %{
    #   "/" => [{"/b.txt", 14848514}, {"/c.dat", 8504156}, {"/a/f", 29116}, {"/a/g", 2557}, {"/a/h.lst", 62596}, {"/a/e/i", 584}],
    #   "/a" => [{"/a/f", 29116}, {"/a/g", 2557}, {"/a/h.lst", 62596}, {"/a/e/i", 584}],
    #   "/a/e" => [{"/a/e/i", 584}],
    #   "/d" => [{"/d/j", 4060174}, {"/d/d.log", 8033020}, {"/d/d.ext", 5626152}, {"/d/k", 7214296}]
    # }
    list
    |> Enum.map(fn { dir, files } ->
       new_files =
        list
        |> Enum.filter(fn { key, _ } -> String.starts_with?(key, dir) and key != dir end)
        |> Enum.reduce([], fn { _, subfiles }, acc -> [subfiles|acc] end)
        |> Enum.flat_map(&(&1))
        { dir, files ++ new_files }
    end)
  end
end




data =
  File.read!("input")
  |> Fs.create_fs()
  |> Fs.add_abs_path()
  |> Fs.get_all_files()
  |> Fs.calc_dir_sizes()

  { total, need } = { 70000000, 30000000 }


{_, {_ , largest}} =
  data
    |> Enum.sort()
    |> Enum.at(0)

free = total - largest
needed = need - free

part2 =
  data
  |> Enum.map(fn {_ , { _, size }} -> size end)
  |> Enum.filter(&(&1 >= needed ))
  |> Enum.at(0)
  # |> IO.inspect() # 12545514
