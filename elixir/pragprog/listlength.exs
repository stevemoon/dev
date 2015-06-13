defmodule ListLength do
  def of([]), do: 0
  def of([head | tail]), do: 1 + of(tail)
end

