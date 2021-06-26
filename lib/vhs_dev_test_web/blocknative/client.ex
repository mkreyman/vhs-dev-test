defmodule VhsDevTest.Blocknative.Client do

  @blocknative_api Application.get_env(:vhs_dev_test, :blocknative)[:api]
  @blocknative_api_key Application.get_env(:vhs_dev_test, :blocknative)[:api_key]

  def call(%{"txid" => hash}) do
    payload =
      %{
        apiKey: @blocknative_api_key,
        hash: hash,
        blockchain: "ethereum",
        network: "main"
      }
      |> Jason.encode!()

    url = @blocknative_api <> "/transaction"
    {:ok, req} = VhsDevTest.Http.Request.new(:post, url, [], payload)

    VhsDevTest.Http.Client.request(req)
  end
end
