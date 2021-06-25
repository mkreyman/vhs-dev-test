defmodule TransactionsCache.Cache do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [
      {:ets_table_name, :transaction_cache_table},
      {:log_limit, 100_000}
    ], opts)
  end

  def fetch(hash, default_value_function) do
    case get(hash) do
      {:not_found} -> set(hash, default_value_function.())
      {:found, result} -> result
    end
  end

  defp get(hash) do
    case GenServer.call(__MODULE__, {:get, hash}) do
      [] -> {:not_found}
      [{_hash, result}] -> {:found, result}
    end
  end

  defp set(hash, value) do
    GenServer.call(__MODULE__, {:set, hash, value})
  end

  # GenServer callbacks

  def handle_call({:get, hash}, _from, state) do
    %{ets_table_name: ets_table_name} = state
    result = :ets.lookup(ets_table_name, hash)
    {:reply, result, state}
  end

  def handle_call({:set, hash, value}, _from, state) do
    %{ets_table_name: ets_table_name} = state
    true = :ets.insert(ets_table_name, {hash, value})
    {:reply, value, state}
  end

  def init(args) do
    [{:ets_table_name, ets_table_name}, {:log_limit, log_limit}] = args

    :ets.new(ets_table_name, [:named_table, :set, :private])

    {:ok, %{log_limit: log_limit, ets_table_name: ets_table_name}}
  end
end
