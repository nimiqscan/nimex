defmodule Nimex.BlockRegistry do
  def init do
    :ets.new(:block_registry, [:named_table])
  end

  def set(block) do
    set(block["number"], block)
    set(block["hash"], block)
  end
  def set(id, block) do
    :ets.insert(:block_registry, {id, block})
  end

  def get(id) do
    case :ets.lookup(:block_registry, id) do
      [{^id, tx}] ->
        {:ok, tx}
      err ->
        {:error, err}
    end
  end

end