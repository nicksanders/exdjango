defmodule ExDjango.CookieTest do
  use ExUnit.Case, async: true
  alias ExDjango.Utils.Cookie
  alias ExDjango.Session

  @secret "6utnz%qfm$fs0legp)e@uxjlk-3hyo8sp4dc-y+x@z(!p=l@l9"

  test "Cookie 1" do
    input = ".eJxVjrsSwiAQRf-F2kQgIWBKZ-y0s2cgbB4aQXk0Ov67ZEyT9u45e-8HmZuyg5NxesDbWUAtOiXvnrA_O2ucRTskVYqjTAG8HFUYM6F74MSIqtGE0w7zGvO-ogfWCE2ErjCvOAPQZCtr1d3Bmuz_O8vO2egnXS5IuV5DeXEG5uPKbh5M2SU5mbOd1LBsBVsMOlOzClF6eCUIMccUE1bgpsD8ikXL6pYy9P0Bm_FM9Q:1Z1WLZ:3jI2GHmVMInuElGvEsK7gVeR5io"
    output = "{\"django_timezone\":\"Europe/London\",\"_auth_user_hash\":\"bfe71d836b172c07407f329568b18b307375eeb1\",\"_auth_user_backend\":\"django.contrib.auth.backends.ModelBackend\",\"_auth_user_id\":1,\"_language\":\"en-gb\",\"last_request\":\"2015-06-07T08:54:25\"}"

    assert Cookie.verify(input, @secret, nil) == {:ok, output}
    assert Cookie.verify(nil, @secret, 0) == {:error, "Invalid Cookie"}
    assert Cookie.verify("egergergegr", @secret, 0) == {:error, "Invalid Cookie"}
    assert Cookie.verify(input, @secret, 0) == {:error, "Session Expired"}
    assert Cookie.verify(input, @secret, 99999999) == {:ok, output}

    {:ok, data} = Cookie.verify(input, @secret, 99999999)
    assert data |> Session.decode() |> Map.get("_auth_user_id") == 1
  end

  test "Cookie 2" do
    input = ".eJxVjj0PgjAYhP9LZ8EWCgFGEzfd3Ju39AQUW6XtovG_W6KL691zHy-mZrJDpAGsY7DZoNmGKYphVNFjUZr6K6xJprkk0OW9s2GZdL4i-c_1-dEZzLsf-1cwrdniXxvJj0k9a123Em2BBkV7JtFAkimrFhKGc4BEyUvep_B3XIXphqez69d9XNwd24OzxtlEzOSDWvCI8GFd5KLKeJMJeRJ1V9SdFOz9ASWLTlE:1ZQHoX:rZaEoy74yvex0aT4dbZdQ8vQkhU"

    {:ok, data} = Cookie.verify(input, @secret, nil)
    assert data |> Session.decode() |> Map.get("_auth_user_id") == "2"
  end

  test "Cookie 3" do
    input = ".eJxVjrsSwiAQRf-F2kSWEExSOmOnnT0DYfPQCBqg0fHfJWOatPece3c_RE7K9lH1SBqCNus12RGpYhhk9DhLrdo7WpOguSXR5a2zYR51vij5Sn1-cQan4-puBsalW2yzQfkhpaIWNXSCIjeVgY63jNVCdwwUK-mh6LQGFChUKv-PyzA-8O3s8uspzu6J-7OzxtlkTMoHOeMrog8JMwplRqsM-BVEU0ADnHx_5ZpNwg:1ZQHsx:2O2F6glRGY4o9pDrLcmljTAT7fI"

    {:ok, data} = Cookie.verify(input, @secret,  nil)
    assert data |> Session.decode() |> Map.get("_auth_user_id") == "3"
  end

end
