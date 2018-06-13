defmodule BlockStream do
  def from(start) do
    Stream.resource(
      fn -> start end,
      fn block_number ->
        {:ok, current_block_number} = Nimex.block_number()

        case block_number <= current_block_number do
          true ->
            {:ok, block} = Nimex.get_block_by_number(block_number)
            {[block], block_number + 1}

          _ ->
            {:halt, block_number}
        end
      end,
      fn block_number -> block_number end
    )
  end
end
