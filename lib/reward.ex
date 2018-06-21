# port from nimiq-network/core/policy
defmodule Nimex.Reward do
  @total_supply 2_100_000_000_000_000
  @initial_supply 252_000_000_000_000
  @emission_speed 4194304
  @emission_tail_start 48692960
  @emission_tail_reward 4000
  
  def supply_after(block_height) do
    get_supply_after(@initial_supply, block_height)
  end

  def reward_at(block_height) do
    current_supply = supply_after(block_height - 1)
    get_reward_at(current_supply, block_height)
  end

  defp get_supply_after(initial_supply, block_height, start_height \\ 0) do
    (start_height .. block_height)
    |> Enum.reduce(initial_supply, fn height, supply ->
      reward = get_reward_at(supply, height)
      supply + reward
    end)
  end

  defp get_reward_at(_, 0), do: 0
  defp get_reward_at(current_supply, block_height) do
    remaining = @total_supply - current_supply
    is_tail = block_height >= @emission_tail_start and remaining >= @emission_tail_reward
    case is_tail do
      true -> @emission_tail_reward
      false ->
        remainder = rem(remaining, @emission_speed)
        div(remaining - remainder, @emission_speed)
    end
  end

end