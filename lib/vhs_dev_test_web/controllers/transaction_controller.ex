defmodule VhsDevTestWeb.TransactionController do
  use VhsDevTestWeb, :controller

  def request_status(conn, %{"txid" => hash}) do
    case VhsDevTest.Blocknative.Client.tx_status(%{"txid" => hash}) do
      %{"msg" => "success"} -> handle_success(conn, "success")
      error -> handle_error(conn, error)
    end
  end

  def watched_transactions(conn, _opts) do
    case VhsDevTest.Blocknative.Client.tx_list() do
      %{"items" => list} -> handle_success(conn, list)
      error -> handle_error(conn, error)
    end
  end

  defp handle_success(conn, message) do
    message =
      message
      |> Jason.encode!

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, message)
  end

  defp handle_error(conn, error) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(422, error)
  end
end
