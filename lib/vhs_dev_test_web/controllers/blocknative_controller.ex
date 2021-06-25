defmodule VhsDevTestWeb.BlocknativeController do
  use VhsDevTestWeb, :controller
  use DebugTest.PipeDebug

  def webhooks(conn, _params) do
    conn
    |> store_transaction()
    |> handle_success()
  end

  defp handle_success(conn) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "ok")
  end

  defp store_transaction(conn) do
    # call cache.set/2
    conn.resp_body
    |> debug("response body")

    conn
  end

  # defp handle_error(conn, error) do
  #   conn
  #   |> put_resp_content_type("text/plain")
  #   |> send_resp(422, error)
  # end
end
