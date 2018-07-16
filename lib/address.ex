defmodule Nimex.Address do
  def from_string(str) do
    {:ok, res} = str
    |> String.replace(" ", "")
    |> NimiqBase32.decode
    << res::size(160) >>
  end
end