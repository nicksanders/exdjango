defmodule ExDjango.SessionTest do
  use ExUnit.Case
  alias ExDjango.Session
  alias ExDjango.Signing

  test "Session" do
    salt = Signing.default_salt
    secret = "6utnz%qfm$fs0legp)e@uxjlk-3hyo8sp4dc-y+x@z(!p=l@l9"
    input = ".eJxVjrsSwiAQRf-F2kQgIWBKZ-y0s2cgbB4aQXk0Ov67ZEyT9u45e-8HmZuyg5NxesDbWUAtOiXvnrA_O2ucRTskVYqjTAG8HFUYM6F74MSIqtGE0w7zGvO-ogfWCE2ErjCvOAPQZCtr1d3Bmuz_O8vO2egnXS5IuV5DeXEG5uPKbh5M2SU5mbOd1LBsBVsMOlOzClF6eCUIMccUE1bgpsD8ikXL6pYy9P0Bm_FM9Q:1Z1WLZ:3jI2GHmVMInuElGvEsK7gVeR5io"
    output = "{\"django_timezone\":\"Europe/London\",\"_auth_user_hash\":\"bfe71d836b172c07407f329568b18b307375eeb1\",\"_auth_user_backend\":\"django.contrib.auth.backends.ModelBackend\",\"_auth_user_id\":1,\"_language\":\"en-gb\",\"last_request\":\"2015-06-07T08:54:25\"}"

    # assert Session.validate(salt, secret, input, nil) == output
    # assert Session.validate(salt, secret, input, 0) == output
    # assert Session.validate(salt, secret, input, 999999) == output
    #
    # session = Session.validate(salt, secret, input, 999999)
    # assert get_user_id(session) == 1
  end

end
