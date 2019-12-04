defmodule CrossedWires do
  @moduledoc """
  Documentation for CrossedWires.
  """

  def run_input(calc_fun \\ &closest_crossing/2) do
    [route_desc_a, route_desc_b] =
      "../../input"
      |> File.read!()
      |> String.split("\n", trime: true, parts: 2)

    IO.puts("Result: #{calc_fun.(route_desc_a, route_desc_b)}")
  end

  @doc """
  Calculate manhattan distances for a crossings
  between 2 lines towards their shared starting point

  ## Examples

      iex> CrossedWires.closest_crossing("R75,D30,R83,U83,L12,D49,R71,U7,L72", "U62,R66,U55,R34,D71,R55,D58,R83")
      159
      iex> CrossedWires.closest_crossing("R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51", "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7")
      135

  """
  def closest_crossing(route_desc_a, route_desc_b) do
    route_a = desc_to_points(route_desc_a)
    route_b = desc_to_points(route_desc_b)
    overlaps = route_a -- [{0, 0} | route_a -- route_b]

    overlaps
    |> Enum.map(&manhattan_distance/1)
    |> Enum.min()
  end

  @doc """
  Calculates crossing which takes the least travelling (with both routes combined).
  This may be not the closest point to origin

  ## Examples

      iex> CrossedWires.least_travelling_crossing("R75,D30,R83,U83,L12,D49,R71,U7,L72", "U62,R66,U55,R34,D71,R55,D58,R83")
      610
      iex> CrossedWires.least_travelling_crossing("R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51", "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7")
      410
  """

  def least_travelling_crossing(route_desc_a, route_desc_b) do
    route_a = desc_to_points(route_desc_a)
    route_b = desc_to_points(route_desc_b)
    overlaps = route_a -- [{0, 0} | route_a -- route_b]

    overlaps
    |> Enum.map(&combined_travel_distance(&1, route_a, route_b))
    |> Enum.min()
  end

  def desc_to_points(desc) do
    desc
    |> String.split(",")
    |> Enum.map(&to_step/1)
    |> Enum.reduce([{0, 0}], &move/2)
    |> Enum.reverse()
  end

  def to_step(<<"R", number::binary>>), do: {:r, number |> String.trim() |> String.to_integer()}
  def to_step(<<"L", number::binary>>), do: {:l, number |> String.trim() |> String.to_integer()}
  def to_step(<<"D", number::binary>>), do: {:d, number |> String.trim() |> String.to_integer()}
  def to_step(<<"U", number::binary>>), do: {:u, number |> String.trim() |> String.to_integer()}

  def move({:r, number}, [{x, y} | _] = acc) do
    new = for new_y <- (y + number)..(y + 1), do: {x, new_y}
    new ++ acc
  end

  def move({:l, number}, [{x, y} | _] = acc) do
    new = for new_y <- (y - number)..(y - 1), do: {x, new_y}
    new ++ acc
  end

  def move({:d, number}, [{x, y} | _] = acc) do
    new = for new_x <- (x - number)..(x - 1), do: {new_x, y}
    new ++ acc
  end

  def move({:u, number}, [{x, y} | _] = acc) do
    new = for new_x <- (x + number)..(x + 1), do: {new_x, y}
    new ++ acc
  end

  def manhattan_distance({x, y}), do: abs(x) + abs(y)

  def combined_travel_distance(point, route_a, route_b),
    do: Enum.find_index(route_a, &(&1 == point)) + Enum.find_index(route_b, &(&1 == point))
end
