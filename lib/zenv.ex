defmodule Zenv do
  @moduledoc """
  Documentation for Zenv.
  """

  @type app :: atom
  @type key :: atom
  @type value :: term

  @doc """
  Returns the value for `key` in `app`'s environment.

  If the configuration parameter does not exist, the function returns the
  `default` value.
  """
  @spec get_env(app, key, value) :: value
  def get_env(app, key, default \\ nil) do
    Application.get_env(app, key, default)
    |> process_env()
  end

  # if the configuration parameter is a {:system, _, _} tuple, attempt to get the value from environment variable
  defp process_env({:system, key, default}) do
    System.get_env(key) || default
  end

  defp process_env({:system, key}) do
    System.get_env(key)
  end

  defp process_env([]) do
    nil
  end

  defp process_env([value | list]) do
    process_env(value) || process_env(list)
  end

  # if the configuration parameter is a value, return the value
  defp process_env(value) do
    value
  end
end
