defmodule IntcodeComputer do
  @moduledoc """
  Documentation for IntcodeComputer.
  """

  @doc """
  Runs compiled program

  ## Examples

      iex> IntcodeComputer.run("1,0,0,0,99")
      "2,0,0,0,99"
      iex> IntcodeComputer.run("2,3,0,3,99")
      "2,3,0,6,99"
      iex> IntcodeComputer.run("2,4,4,5,99,0")
      "2,4,4,5,99,9801"
      iex> IntcodeComputer.run("1,1,1,4,99,5,6,0,99")
      "30,1,1,4,2,5,6,0,99"

  """
  def run(program) when is_binary(program) do
    program
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
    |> run
  end

  def run(data), do: run(data, 0, data)

  def run([1, pos_a, pos_b, pos_res | _rest], pc, program) do
    new_program =
      List.replace_at(program, pos_res, Enum.at(program, pos_a) + Enum.at(program, pos_b))

    new_pc = pc + 4
    run(Enum.drop(new_program, new_pc), new_pc, new_program)
  end

  def run([2, pos_a, pos_b, pos_res | _rest], pc, program) do
    new_program =
      List.replace_at(program, pos_res, Enum.at(program, pos_a) * Enum.at(program, pos_b))

    new_pc = pc + 4
    run(Enum.drop(new_program, new_pc), new_pc, new_program)
  end

  def run([99 | _], _pc, program), do: Enum.join(program, ",")

  def preprocess(program, noun \\ 12, verb \\ 2) do
    program
    |> String.split(",")
    |> List.replace_at(1, to_string(noun))
    |> List.replace_at(2, to_string(verb))
    |> Enum.join(",")
  end

  def run_input(noun \\ 12, verb \\ 2) do
    "../../input"
    |> File.read!()
    |> preprocess(noun, verb)
    |> run()
    |> String.split(",")
    |> hd
    |> String.to_integer()
  end

  def find_output(number \\ 19_690_720) do
    for noun <- 0..99, verb <- 0..99, number == run_input(noun, verb), do: 100 * noun + verb
  end
end
