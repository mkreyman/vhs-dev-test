defmodule VhsDevTestWeb.TransactionController do
  use VhsDevTestWeb, :controller

  @api_key Application.get_env(:vhs_dev_test, :blocknative)[:api_key]

  def request_status(conn, %{"txid" => hash}) do
    payload = %{
      apiKey: @api_key,
      hash: hash,
      blockchain: "ethereum",
      network: "main"
    }
    |> Jason.encode!()

    {:ok, req} = VhsDevTest.Blocknative.Request.new(:post, "/transaction", [], payload)

    case VhsDevTest.Blocknative.Client.request(req) do
      %{"msg" => "success"} -> handle_success(conn)
      error -> handle_error(conn, error)
    end
  end

  defp handle_success(conn) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "ok")
  end

  defp handle_error(conn, error) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(422, error)
  end
end
