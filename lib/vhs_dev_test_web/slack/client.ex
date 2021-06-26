defmodule VhsDevTest.Slack.Client do
  @slack_webhook Application.get_env(:vhs_dev_test, :slack)[:webhook]

  def call(%{"hash" => hash, "status" => status}) do
    payload =
      %{text: "txid: #{hash}, status: #{status}"}
      |> Jason.encode!()

    {:ok, req} = VhsDevTest.Http.Request.new(:post, @slack_webhook, [], payload)

    VhsDevTest.Http.Client.request(req)
  end
end
