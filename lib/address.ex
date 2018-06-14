defmodule Nimex.Address do
  def from_string(str) do
    str
    |> String.replace(" ", "")
    |> Base.decode64!
  end
end