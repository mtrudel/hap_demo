defmodule HAPDemoTest do
  use ExUnit.Case
  doctest HAPDemo

  test "greets the world" do
    assert HAPDemo.hello() == :world
  end
end
