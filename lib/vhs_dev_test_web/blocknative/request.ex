defmodule VhsDevTest.Blocknative.Request do

  import Ecto.Changeset
  # use DebugTest.PipeDebug

  alias __MODULE__, warn: false

  @api Application.get_env(:vhs_dev_test, :blocknative)[:api]

  @schema %{
    method: :string,
    headers: :any,
    url: :string,
    query: :any,
    payload: :any
  }

  @required_fields [:method, :headers, :url, :query]

  defstruct [:method, :headers, :url, :query, :payload]

  def new(method, resource, query \\ [])
  def new(method, resource, query) when is_binary(method) do
    params = %{method: method, headers: build_headers(), url: build_url(resource), query: query}
    # |> debug("params")

    cast({%Request{}, @schema}, params, @required_fields)
    |> apply_action(:insert)
  end

  def new(method, resource, query) when is_atom(method) do
    method
    |> Atom.to_string()
    |> Request.new(resource, query)
  end

  def changeset(request \\ %Request{}, params \\ %{}) do
    {request, @schema}
    |> cast(params, @required_fields)
    |> validate()
  end

  defp validate(changeset) do
    changeset
    |> validate_required(@required_fields)
  end

  defp build_url("/transaction" = resource) do
    @api <> resource
  end

  defp build_headers() do
    ["Content-Type": "application/json"]
    # |> debug("headers")
  end
end
