defmodule Vamp do
  @moduledoc """
  Documentation for Vamp
  """
  use Supervisor

  def factor_pairs(n) do
    first = trunc(n / :math.pow(10, div(char_len(n), 2)))
    last  = :math.sqrt(n) |> round
    for i <- first .. last, rem(n, i) == 0, do: {i, div(n, i)}
  end

  def vampire_factors(n, len) when rem(len, 2) == 1, do: []
  def vampire_factors(n, len) do
      half = div(char_len(n), 2)
      sorted = Enum.sort(String.codepoints("#{n}"))
      Enum.filter(factor_pairs(n), fn {a, b} ->
        char_len(a) == half && char_len(b) == half &&
        Enum.count([a, b], fn x -> rem(x, 10) == 0 end) != 2 &&
        Enum.sort(String.codepoints("#{a}#{b}")) == sorted
      end)

    end

  defp char_len(n), do: length(to_charlist(n))

  def format_output(number, vf) do
    output = [number]
    output = Enum.join(Enum.reduce(vf, output,
             fn {a, b}, acc -> acc ++ [a] ++ [b] end), " ")
    IO.puts "#{inspect output}"
    {:reply, number}
  end

  def task(args) do
    [a, b] = for arg <- args, do: String.trim(arg) |> String.to_integer
    numbers = for n <- a..b, do: n
    numlst = Enum.chunk_every(numbers, 8, 8)
    children = for {list, counter} <- Enum.with_index(numlst), do: worker(Vamp.Worker, [list], id: counter)

    opts = [strategy: :one_for_one, name: Vamp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
