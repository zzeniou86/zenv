defmodule ZenvTest do
  use ExUnit.Case
  doctest Zenv

  # "setup_all" is called once per module before any test runs
  setup_all do
    Application.put_env(:zenv, :test_case_1, "it_works")
    System.put_env("ZENV_ENV", "zenv_env_1")
    Application.put_env(:zenv, :test_case_2, {:system, "ZENV_ENV", "default_env"})
    Application.put_env(:zenv, :test_case_3, {:system, "ZENV_ENV"})
    Application.put_env(:zenv, :test_case_4, {:system, "DOES_NOT_EXISTS", "default_env"})
    Application.put_env(:zenv, :test_case_5, {:system, "DOES_NOT_EXISTS"})
    :ok
  end

  describe "Zenv.get_env/3" do
    test "returns nil when environment variable does not exist and default is not provided" do
      assert Zenv.get_env(:zenv, :test_case_5) == nil
    end

    test "returns default value in tuple when environment variable does not exist" do
      assert Zenv.get_env(:zenv, :test_case_4) == "default_env"
    end

    test "returns environment variable when {:system, _} tuple is supplied" do
      assert Zenv.get_env(:zenv, :test_case_3) == "zenv_env_1"
    end

    test "returns environment variable when {:system, _, _} tuple is supplied" do
      assert Zenv.get_env(:zenv, :test_case_2) == "zenv_env_1"
    end

    test "replaces Application.get_env/3" do
      # make sure key value is defined
      assert Application.get_env(:zenv, :test_case_1) !== nil

      assert Zenv.get_env(:zenv, :test_case_1) == Application.get_env(:zenv, :test_case_1)
      assert Zenv.get_env(:zenv, :does_not_exists) == Application.get_env(:zenv, :does_not_exists)

      assert Zenv.get_env(:zenv, :does_not_exists, "default") ==
               Application.get_env(:zenv, :does_not_exists, "default")
    end

    test "returns nil when key does not exists and default is not supplied" do
      assert Zenv.get_env(:zenv, :does_not_exists) == nil
    end

    test "returns the default value when key does not exists" do
      assert Zenv.get_env(:zenv, :does_not_exists, "default") == "default"
    end

    test "returns the correct value when key exists" do
      assert Zenv.get_env(:zenv, :test_case_1, "default") == "it_works"
    end
  end
end
