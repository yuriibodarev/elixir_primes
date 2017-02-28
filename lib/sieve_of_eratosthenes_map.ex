defmodule Primes.SieveOfEratosthenes.Map do
  @moduledoc """
  Implement Sieve of Eratosthenes algorithm for finding all prime numbers up to any given limit.
  Uses MapSet to store the list of integers for sieving.
  """

  alias Primes.Helper.Sequence

  @doc """
  Returns the list of the prime numbers up to the given limit.
  Limit must be integer larger than 1.

  ## Examples

     iex> Primes.SieveOfEratosthenes.Map.get_primes_list(10)
     [2, 3, 5, 7]

  """
  @spec get_primes_list(pos_integer) :: [pos_integer]
  def get_primes_list(limit) when limit == 2, do: [2]

  def get_primes_list(limit) when limit > 2 do
    odds = Sequence.get_odd(3, limit)
    map = Map.new(odds, &{&1, true})

    sieve(odds, map, limit)
  end

  defp sieve([], map, _), do: get_primes(map)
  defp sieve([h | _], map, limit) when h * h > limit, do: get_primes(map)

  defp sieve([h | t], map, limit) do
    new_map =
      if Map.get(map, h, false), do: mark_composites(h, map, limit), else: map

    sieve(t, new_map, limit)
  end

  defp get_primes(map) do
      Enum.reduce(map, [2], fn({num, is_prime}, acc) ->
        if is_prime, do: [num | acc], else: acc
      end)
      |> Enum.sort()
  end

  defp mark_composites(first, map, limit) do
    composite_map =
      Sequence.get(first * first, limit, 2 * first)
      |> Map.new(&{&1, false})

    Map.merge(map, composite_map)
  end
end
