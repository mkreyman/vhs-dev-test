defmodule VhsDevTest.Http.Request do
  import Ecto.Changeset
  # use DebugTest.PipeDebug

  alias __MODULE__, warn: false

  @schema %{
    method: :string,
    headers: :any,
    url: :string,
    query: :any,
    payload: :any
  }

  @required_fields [:method, :headers, :url, :query, :payload]

  defstruct [:method, :headers, :url, :query, :payload]

  def new(method, url, query \\ [], payload)

  def new(method, url, query, payload) when is_binary(method) do
    params = %{
      method: method,
      headers: build_headers(),
      url: url,
      query: query,
      payload: payload
    }

    # |> debug("params")

    cast({%Request{}, @schema}, params, @required_fields)
    |> apply_action(:insert)
  end

  def new(method, url, query, payload) when is_atom(method) do
    method
    |> Atom.to_string()
    |> Request.new(url, query, payload)
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

  defp build_headers() do
    ["Content-Type": "application/json"]
    # |> debug("headers")
  end
end
