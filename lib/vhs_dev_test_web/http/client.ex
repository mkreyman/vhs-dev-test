defmodule VhsDevTest.Http.Client do
  # use DebugTest.PipeDebug
  alias VhsDevTest.Http.Request

  @http_client Application.get_env(:vhs_dev_test, :http_client)
  @http_client_options [with_body: true]

  def request(%Request{
        method: method,
        headers: headers,
        url: url,
        query: query,
        payload: payload
      }) do
    url =
      url
      |> process_url()
      |> process_query(query)

    proxy = System.get_env("https_proxy")

    options =
      if Application.get_env(:vhs_dev_test, :env) == :dev and valid_proxy?(proxy) do
        [{:proxy, proxy}] ++ @http_client_options
      else
        @http_client_options
      end

    params =
      case payload do
        nil -> [url, headers, options]
        _ -> [url, payload, headers, options]
      end

    method = String.to_existing_atom(method)

    case apply(@http_client, method, params) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        try do
          Jason.decode!(body)
        rescue
          _ -> body
        end

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        "Not found :("

      {:error, %HTTPoison.Error{reason: reason}} ->
        reason
    end
  end

  defp process_url(url) do
    case String.downcase(url) do
      <<"http://"::utf8, _::binary>> -> url
      <<"https://"::utf8, _::binary>> -> url
    end
  end

  defp process_query(url, nil), do: url
  defp process_query(url, []), do: url
  defp process_query(url, query), do: url <> "?" <> URI.encode_query(query)

  defp valid_proxy?(proxy) when is_binary(proxy) do
    byte_size(proxy) > 0 && String.match?(proxy, ~r/^http/)
  end

  defp valid_proxy?(_), do: false
end
