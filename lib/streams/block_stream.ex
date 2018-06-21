defmodule Nimex.BlockStream do
  def from(start) do
    Stream.resource(
      fn -> start end,
      fn next_block_number ->
        # will block till it gets a new block
        block = get_block(next_block_number)
        case block do
          {:ok, block} ->
            {[{:ok, block}], next_block_number + 1}
          {:error, error} ->
            {:halt, error}
        end
      end,
      fn block_number -> block_number end
    )
  end
  defp get_head_block_number() do
    case Nimex.block_number() do
      {:ok, head_block_number} ->
        {:ok, head_block_number}
      {:error, _} ->
        IO.puts "failed to get head block number"
        # wait 5 sec before polling after error
        Process.sleep(5000)
        get_head_block_number()        
    end
  end
  defp get_block(block_number) do
    {:ok, head_block_number} = get_head_block_number()

    cond do
      block_number <= head_block_number ->
        case Nimex.get_block_by_number(block_number) do
          {:ok, block} ->
            {:ok, block}
          {:error, _} ->
            IO.puts "failed to get block #{block_number}"
            # wait 5 sec before polling after error
            Process.sleep(5000)
            get_block(block_number)
        end
      block_number > head_block_number ->
        # wait 1 sec before polling again
        Process.sleep(1000)
        get_block(block_number)
    end
  end
end
