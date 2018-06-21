defmodule Nimex do
  defp config do
    [
      {:rpc_host, System.get_env("RPC_HOST")},
      {:rpc_username, System.get_env("RPC_USERNAME")},
      {:rpc_password, System.get_env("RPC_PASSWORD")}
    ]
  end


  defp call(method, params \\ nil, retries \\ 3) do
    body =
      Poison.encode!(%{
        jsonrpc: "2.0",
        method: method,
        params: params,
        id: 42, 
      })

    config = config()

    response = HTTPoison.post(
      config[:rpc_host],
      body,
      [],
      [
        follow_redirect: true, max_redirect: 5,
        hackney: [basic_auth: {config[:rpc_username], config[:rpc_password]},]
      ]
    )

    case response do
      {:ok, %{body: body}} ->
        case Poison.decode(body) do
          {:ok, %{"result" => result}} ->
            {:ok, result}

          {:error, error} ->
            {:error, error}
        end
      {:error, response} ->
        if retries <= 0 do
          {:error, response}
        else
          call(method, params, retries - 1)
        end
    end

  end

  # Network
  def peer_count(), do: call("peerCount")
  def syncing(), do: call("syncing")
  def consensus(), do: call("consensus")
  def peer_list(), do: call("peerList")
  def peer_state(), do: call("peerState")

  # Transactions
  def send_raw_transaction(raw_tx), do: call("sendRawTransaction", [raw_tx])
  def send_transaction(tx), do: call("sendTransaction", [tx])

  def get_transaction_by_block_hash_and_index(block_hash, index),
    do: call("getTransactionByBlockHashAndIndex", [block_hash, index])

  def get_transaction_by_block_number_and_index(block_number, index),
    do: call("getTransactionByBlockNumberAndIndex", [block_number, index])

  def get_transaction_by_hash(hash), do: call("getTransactionByHash", [hash])
  def get_transaction_receipt(txid), do: call("getTransactionReceipt", [txid])
  def get_transactions_by_address(address), do: call("getTransactionsByAddress", [address])
  def mempool_content(), do: call("mempoolContent")
  def mempool(), do: call("mempool")
  def min_fee_per_byte(), do: call("minFeePerByte")

  # Miner
  def mining(), do: call("mining")
  def hashrate(), do: call("hashrate")
  def miner_threads(), do: call("minerThreads")

  # Accounts
  def accounts(), do: call("accounts")
  def create_account(account), do: call("createAccount", [account])
  def get_balance(address), do: call("getBalance", [address])
  def get_account(address), do: call("getAccount", [address])

  # Blockchain
  def block_number(), do: call("blockNumber")

  def get_block_transaction_count_by_hash(hash),
    do: call("getBlockTransactionCountByHash", [hash])

  def get_block_transaction_count_by_number(number),
    do: call("getBlockTransactionCountByNumber", [number])

  def get_block_by_hash(hash), do: call("getBlockByHash", [hash])
  def get_block_by_number(number), do: call("getBlockByNumber", [number])

  def constant(), do: call("constant")
  def log(), do: call("log")
end


