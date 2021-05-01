defmodule Issues.TableFormatter do

  def print_table_data(data, columns) do 
    cws = Enum.reduce(columns, [], fn col, acc ->
      acc ++ ["#{col}": get_max_width(col, data)]
    end)

    thead = print_headers(cws)
    tbody = print_body(data, cws)

    lines = thead ++ tbody
    Enum.join(lines, "\n")
  end

  defp printable(str) when is_binary(str), do: str
  defp printable(str), do: to_string(str)

  defp get_max_width(col, tabledata) do
    tabledata 
         |> Enum.map(&(printable(&1[col]))) 
         |> Enum.map(&(String.length/1))
         |> Enum.max
  end

  def print_headers(cws) do
    headline = cws
      |> Enum.map(fn {col, width} -> String.pad_trailing(Atom.to_string(col), width) end) 
      |> Enum.join(" | ")
    dividerline = cws
                  |> Enum.map(fn {_col, width} -> String.pad_trailing("", width, "-") end)
                  |> Enum.join("-+-")
    [headline, dividerline]
  end

  def print_body(data, cws) do
    data 
      |> Enum.map(fn linedata -> 
        linedata 
          |> Enum.map(fn {col, value} -> String.pad_trailing(value, cws[col]) end) 
          |> Enum.join(" | ")
      end)
  end
end
