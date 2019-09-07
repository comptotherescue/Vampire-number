defmodule Vamp.Worker do
  use GenServer

  def start_link(numlst) do
    GenServer.start_link(__MODULE__, numlst)
  end

  # Server API
  @impl true
  def handle_cast({:check, number}, state) do
    len = length(to_charlist(number))
    case Vamp.vampire_factors(number, len) do
      [] -> {:noreply, number}
      vf -> Vamp.format_output(number, vf)
    end

    {:noreply, number}
  end

  defp char_len(n), do: length(to_charlist(n))

  def check_vamp(pid, number) do
    GenServer.cast(pid, {:check, number})
  end

  @impl true
  def init(args) do
    for i <- args do
      check_vamp(self(), i)
    end
    {:ok, args}
  end
end
