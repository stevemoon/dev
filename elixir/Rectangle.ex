defmodule Rectangle do
  def area({w, h}), do: h * w
  def perimeter({w, h}), do: 2 * (w + h)
end

