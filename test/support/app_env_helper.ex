defmodule Test.Support.AppEnvHelper do
  @moduledoc """
  Helpers for working with app env.
  """

  @doc """
  Unquotes an expression with a given app env set to the
  specified value, then restores it to it's original value.

  Accepts a single key and value or a map.

  Example:
  ```
  import Test.Support.AppEnvHelper
  Application.put_env(:myapp, :foo, :bar)
  with_app_env(:myapp, :foo, :baz) do
    IO.inspect Application.get_env(:myapp, :foo), label: "myapp.foo <in block>"
  end
  IO.inspect Application.get_env(:myapp, :foo), label: "myapp.foo <after block>"

  > myapp.foo <in block>: :baz
  > myapp.foo <after block>: :bar
  ```
  """
  defmacro with_app_env(app, key, value, expr) do
    quote location: :keep do
      prev_value = Application.get_env(unquote(app), unquote(key))
      Application.put_env(unquote(app), unquote(key), unquote(value))

      try do
        unquote(expr)
      after
        Application.put_env(unquote(app), unquote(key), prev_value)
      end
    end
  end

  defmacro with_app_env(app, map, expr) do
    quote location: :keep do
      old =
        Enum.map(unquote(map), fn {k, v} ->
          {k, Application.get_env(unquote(app), k)}
        end)

      old = Map.new(old)

      Enum.each(unquote(map), fn {k, v} ->
        Application.put_env(unquote(app), k, v)
      end)

      try do
        unquote(expr)
      after
        Enum.map(old, fn {k, v} ->
          Application.put_env(unquote(app), k, v)
        end)
      end
    end
  end
end
