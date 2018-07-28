defmodule Trabaho do
  @moduledoc """
  Documentation for Trabaho.
  """

  defmodule Pangasiwaan do
    def simulan(impormasyon, tungkulin) do
      {:ok, :proc_lib.spawn(__MODULE__, :noreply, [impormasyon, tungkulin])}
    end

    def noreply(impormasyon, mfa) do
      paunang_tawag(mfa)
    end

    defp paunang_tawag(mfa) do
      Process.put("$initial_call", ang_paunang_tawag(mfa))
    end

    defp ang_paunang_tawag({:erlang, :apply, [fun, []]}) when is_function(fun, 0) do
      {:module, module} = :erlang.fun_info(fun, :module)
      {:name, name} = :erlang.fun_info(fun, :name)
      {module, name, 0}
    end
  end

  @doc """
  Hello world.

  ## Examples

      iex> Trabaho.hello
      :world

  """
  def hello do
    :world
  end

  @doc """
  Links `Trabaho` to the calling process
  """
  def start_link(fun) do
    start_link(:erlang, :apply, [fun, []])
  end

  def start_link(mod, fun, args) do
    IO.inspect mod
  end

  def simulan(tungkulin) do
    simulan(:erlang, :apply, [tungkulin, []])
  end

  def simulan(module, tungkulin, argumento) do
    Pangasiwaan.simulan(get_info(self()), {module, tungkulin, argumento})
  end

  defp get_info(pid) do
    self_or_name =
      case Process.info(pid, :registered_name) do
        {:registered_name, name} when is_atom(name) -> name
        _ -> pid
      end

    {node(), self_or_name}
  end
end
