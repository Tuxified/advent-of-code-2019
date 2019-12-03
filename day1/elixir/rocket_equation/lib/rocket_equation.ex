defmodule RocketEquation do
  @moduledoc """
  Documentation for RocketEquation.
  """

  @doc """
  Calculates amount of fuel needed based on module mass

  ## Examples

      iex> RocketEquation.fuel(14)
      2
      iex> RocketEquation.fuel(1969)
      654
      iex> RocketEquation.fuel(100756)
      33583
  """
  def fuel(mass) do
    (div(mass, 3) - 2)
    |> max(0)
  end

  @doc """
  Calculates amount of fuel needed based on modules mass
  and the fuel needed therefore etc, until it's certain
  there is enough to carry the module and it's fuel
  
  ## Examples

      iex> RocketEquation.fuels_fuel(1969)
      966
      iex> RocketEquation.fuels_fuel(100756)
      50346

  """

  def fuels_fuel(mass), do: fuels_fuel(fuel(mass), fuel(mass))

  defp fuels_fuel(total, 0), do: total
  defp fuels_fuel(total, last) do
    fuel = fuel(last)
    fuels_fuel(total + fuel, fuel)
  end

  def start(:normal, []) do
    {:ok, spawn( &run/0 )}
  end

  def run( calc_fun \\ &fuel/1) do
    "../../input"
    |> File.open!([:read])
    |> IO.stream(:line)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
    |> Stream.map(calc_fun)
    |> Enum.sum
    |> IO.inspect(label: "Total fuel needed: ")
  end
end
