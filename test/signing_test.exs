defmodule ExDjango.SigningTest do
  use ExUnit.Case, async: true
  alias ExDjango.Utils.Signing

  test "Signing b64_decode" do
    input = "dpzEj8pbu98e1vde2zSv-0DbQ7o"
    output = <<118, 156, 196, 143, 202, 91, 187, 223, 30, 214, 247, 94, 219, 52, 175, 251, 64, 219, 67, 186>>
    assert Signing.b64_decode(input) == output
  end

  test "Signing base64_hmac" do
    salt = Signing.default_salt
    secret = "secret"
    input = "hey there dude"
    output = "cRW28cBU8dYu_qWqEzvIQw3dwMI"
    assert Signing.base64_hmac(salt, secret, input) == output
  end

end
