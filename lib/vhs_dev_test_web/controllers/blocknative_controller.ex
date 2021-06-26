defmodule VhsDevTestWeb.BlocknativeController do
  use VhsDevTestWeb, :controller

  def webhooks(conn, _params) do
    conn
    |> notify_slack()
    |> store_transaction()
    |> handle_success()
  end

  def notify_slack(conn) do
    %Plug.Conn{body_params: body} = conn
    spawn_link(VhsDevTest.Slack.Client, :call, [body])
    conn
  end

  defp handle_success(conn) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "ok")
  end

  defp store_transaction(%Plug.Conn{body_params: body} = conn) do
    key = body["hash"]
    TransactionsCache.Cache.fetch(key, fn -> body end)
    conn
  end

  # defp handle_error(conn, error) do
  #   conn
  #   |> put_resp_content_type("text/plain")
  #   |> send_resp(422, error)
  # end
end
