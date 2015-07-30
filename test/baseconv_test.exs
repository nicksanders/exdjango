defmodule ExDjango.BaseConvTest do
  use ExUnit.Case
  alias ExDjango.BaseConv

  test "BaseConv base62" do
    assert BaseConv.decode(:base62, "1Z1WLZ") == 1433667265
    assert BaseConv.encode(:base62, "1433667265") == "1Z1WLZ"
  end

  test "BaseConv base64" do
    assert BaseConv.decode(:base64, "$1Z1WLZ") == -1661338979
    assert BaseConv.encode(:base64, "-1661338979") == "$1Z1WLZ"
  end

  test "BaseConv custom" do
    assert BaseConv.decode("0123456789-", "$", "$-22") == -1234
    assert BaseConv.encode("0123456789-", "$", "-1234") == "$-22"
  end

end
