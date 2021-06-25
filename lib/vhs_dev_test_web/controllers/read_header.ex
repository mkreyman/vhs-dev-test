defmodule VhsDevTestWeb.ReadHeader do
  @moduledoc """
  A plug to be used in troubleshooting responses.
  """

  @behaviour Plug

  import Plug.Conn, warn: false
  use DebugTest.PipeDebug

  def init(config), do: config

  def call(conn, _config) do
    conn
    |> debug("VhsDevTestWeb.ReadHeader plug")
  end
end
