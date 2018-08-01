defmodule Nimex.Address do
  @address_prefix "NQ"
  
  def from_string(str) do
    {:ok, res} = str
    |> String.replace(" ", "")
    |> NimiqBase32.decode
    << res::size(160) >>
  end

  def iban_check(addr) do
    addr
    |> String.upcase
    |> String.to_charlist
    |> Enum.map(fn c ->
      is_numeric = c >= 48 && c <= 57
      case is_numeric do
        true ->
          [c]
        false ->
          c - 55
      end
    end)
    |> Enum.map(&to_string/1)
    |> Enum.join
    |> (fn x -> Regex.scan(~r/.{1,6}/, x) end).()
    |> List.flatten
    |> Enum.reduce("", fn x, acc -> to_string(rem(String.to_integer(acc <> x), 97)) end)
    |> String.to_integer
  end

  def to_user_friendly_addr(binary_addr) do
    << int::size(160) >> = binary_addr
    base32 = NimiqBase32.encode(int)

    check = "00" <> to_string(98 - iban_check(base32 <> @address_prefix <> "00"))
    check = String.slice(check, String.length(check) - 2, 2)

    addr = @address_prefix <> check <> base32
    addr
    |> (fn x -> Regex.scan(~r/.{1,4}/, x) end).()
    |> Enum.join(" ")
  end

end