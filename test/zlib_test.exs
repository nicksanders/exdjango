defmodule ExDjango.ZlibTest do
  use ExUnit.Case, async: true
  alias ExDjango.Utils.Zlib

  test "Zlib" do
    text = "test"
    result = Zlib.compress(text)
    assert Zlib.decompress(result) == text
  end

end
