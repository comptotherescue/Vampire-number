defmodule Vamp.CLI do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  def start(_type, _args) do
    main(System.argv())
  end

  def main(args) do
    args |> Vamp.task
  end
end
