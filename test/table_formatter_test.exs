defmodule TableFormatterTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  alias Issues.TableFormatter, as: TF

  test "print table for columns" do
    rows = 2
    columns = 2
    table = fake_table_data(rows, columns)
      |> TF.print_table_data([:c0, :c1, :c2])
    IO.puts """
    #{table}
    """
  end

  test "print headers" do 
    headers = TF.print_headers([a: 3, b: 5]) 
    assert headers == ["a   | b    ", "----+------"]
  end

  test "print body" do 
    data = [ [a: "r1", b: "r1"], [a: "r2", b: "r2xx"] ]
    cws = [a: 3, b: 5]
    body = TF.print_body(data, cws) 
    assert body == ["r1  | r1   ", "r2  | r2xx "]
  end

  defp fake_table_data(rows, columns) do
    Enum.map(0..rows, &(fake_row_data(&1, columns)))
  end

  defp fake_row_data(row, columns) do
    Enum.reduce(0..columns, [], fn col, acc -> 
      acc ++ ["c#{col}": "[row_#{row},col_#{col}]"]
    end )
  end
end
