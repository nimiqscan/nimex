defmodule Nimex.TransactionRegistry do
  def init do
    :ets.new(:transaction_registry, [:named_table])
  end

  def set(tx) do
    set(tx["hash"], tx)
  end

  def set(id, tx) do
    :ets.insert(:transaction_registry, {id, tx})
  end

  def get(id) do
    case :ets.lookup(:transaction_registry, id) do
      [{^id, tx}] ->
        {:ok, tx}
      err ->
        {:error, err}
    end
  end

end