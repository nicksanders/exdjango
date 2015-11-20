defmodule ExDjango.BaseconvTest do
  use ExUnit.Case, async: true
  alias ExDjango.Utils.Baseconv

  test "Baseconv base62" do
    assert Baseconv.decode(:base62, "1Z1WLZ") == 1433667265
    assert Baseconv.encode(:base62, "1433667265") == "1Z1WLZ"
  end

  test "Baseconv base64" do
    assert Baseconv.decode(:base64, "$1Z1WLZ") == -1661338979
    assert Baseconv.encode(:base64, "-1661338979") == "$1Z1WLZ"
  end

  test "Baseconv custom" do
    assert Baseconv.decode("0123456789-", "$", "$-22") == -1234
    assert Baseconv.encode("0123456789-", "$", "-1234") == "$-22"
  end

end
