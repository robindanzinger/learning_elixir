defmodule CLITest do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI, only: [parse_args: 1, sort_into_descending_order: 1]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "three values returned if three given" do
    assert parse_args(["user", "project", "99"]) == {"user", "project", 99}
  end

  test "count is defaulted if two values given" do
    assert parse_args(["user", "project"]) == {"user", "project", 4}
  end

  test "sort descending orders the correct way" do
    result = sort_into_descending_order(fake_created_at_list(["c", "a", "b"]))
    issues = for issue <- result, do: Map.get(issue, "created_at")
    assert issues == ~w{c b a}
  end

  test "print table for columns" do
    rows = 2
    columns = 2
    table = fake_table_data(rows, columns)
      |> print_table_data([:c0, :c1, :c2])
    IO.puts """
    #{table}
    """
  end

  test "print headers" do 
    headers = print_headers([a: 3, b: 5]) 
    assert headers == ["a  |b    ", "---+-----"]
  end

  test "print body" do 
    data = [ [a: "r1", b: "r1"], [a: "r2", b: "r2xx"] ]
    cws = [a: 3, b: 5]
    body = print_body(data, cws) 
    assert body == ["r1 |r1   ", "r2 |r2xx "]
  end

  defp fake_created_at_list(values) do
    for value <- values,
      do: %{"created_at" => value, "other_data" => "xxx"}
  end

  defp fake_table_data(rows, columns) do
    Enum.map(0..rows, &(fake_row_data(&1, columns)))
  end

  defp fake_row_data(row, columns) do
    Enum.reduce(0..columns, [], fn col, acc -> 
      acc ++ ["c#{col}": "[row_#{row},col_#{col}]"]
    end )
  end

  defp print_table_data(data, columns) do 
    cws = Enum.reduce(columns, [], fn col, acc ->
      acc ++ ["#{col}": get_max_width(col, data)]
    end)

    thead = print_headers(cws)
    tbody = print_body(data, cws)

    lines = thead ++ tbody
    Enum.join(lines, "\n")
  end

  defp get_max_width(col, tabledata) do
    tabledata 
         |> Enum.map(&(&1[col])) 
         |> Enum.map(&(String.length/1))
         |> Enum.max
  end

  defp print_headers(cws) do
    headline = cws
      |> Enum.map(fn {col, width} -> String.pad_trailing(Atom.to_string(col), width) end) 
      |> Enum.join("|")
    dividerline = cws
                  |> Enum.map(fn {_col, width} -> String.pad_trailing("", width, "-") end)
                  |> Enum.join("+")
    [headline, dividerline]
  end

  defp print_body(data, cws) do
    data 
      |> Enum.map(fn linedata -> 
        linedata 
          |> Enum.map(fn {col, value} -> String.pad_trailing(value, cws[col]) end) 
          |> Enum.join("|")
      end)
  end
end
