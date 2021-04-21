defmodule IssueTest do
  use ExUnit.Case
  doctest Issue

  test "greets the world" do
    assert Issue.hello() == :world
  end
end
