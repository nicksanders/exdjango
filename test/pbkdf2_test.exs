defmodule ExDjango.Pbkdf2Test do
  use ExUnit.Case, async: true

  alias ExDjango.Pbkdf2

  def check_vectors(data) do
    for {password, salt, rounds, stored_hash} <- data do
      assert Pbkdf2.hashpass(password, salt, rounds) == stored_hash
      assert Pbkdf2.hashpass(password, salt, rounds, :sha256) == stored_hash
    end
  end

  def check_checkpw(data) do
    for {password, _salt, _rounds, stored_hash} <- data do
      assert Pbkdf2.checkpw(password, stored_hash) == true
    end
  end

  def hash_check_password(password, wrong1, wrong2, wrong3) do
    hash = Pbkdf2.hashpwsalt(password)
    assert Pbkdf2.checkpw(password, hash) == true
    assert Pbkdf2.checkpw(wrong1, hash) == false
    assert Pbkdf2.checkpw(wrong2, hash) == false
    assert Pbkdf2.checkpw(wrong3, hash) == false
  end

  @password_hashes [
    {"pa$$word",
      "xvJitqXFKLDy",
      20_000,
      "pbkdf2_sha256$20000$xvJitqXFKLDy$CEzm5tv/2IVR5vT1pgN1B9ebo3n62xktmhClSuMsrM4="},
    {"passDATAb00AB7YxDTT",
      "7T4cGyTsIqXl",
      20_000,
      "pbkdf2_sha256$20000$7T4cGyTsIqXl$SGp9lb20DSYXk1SY80NxFlGPOIN8apThVNanlL628aw="},
    {"passDATAb00AB7YxDTTl",
      "pOIkJ2DADj78",
      20_000,
      "pbkdf2_sha256$20000$pOIkJ2DADj78$6/xhxGrCHGUJsQSs16V5s1GtucMSgGdtfVKmCyJsv58="},
    {"passDATAb00AB7YxDTTlRH2dqxDx19GDxDV1zFMz7E6QVqKIzwOtMnlxQLttpE5",
      "T1TgNUPEvPnc",
      20_000,
      "pbkdf2_sha256$20000$T1TgNUPEvPnc$OBc2b5qo+EoPbkPEr1m4Vcbc8ip2IYG/AfiiIgB4vcQ="},
  ]

  test "Django pbkdf2_sha256 hashpass tests" do
    @password_hashes |> check_vectors
  end

  test "Django pbkdf2_sha256 checkpw tests" do
    @password_hashes |> check_checkpw
  end

  test "Comeonin pbkdf2_sha512 tests" do
    [
      {"passDATAb00AB7YxDTT",
        "saltKEYbcTcXHCBxtjD",
        100_000,
        "$pbkdf2-sha512$100000$c2FsdEtFWWJjVGNYSENCeHRqRA$rM3Nh5iuXNhYBHOQFe8qEeMlkbe30W92gZswsNSdgOGr6myYIrgKH9/kIeJvVgPsqKR6ZMmgBPta.CKfdi/0Hw"},
      {"passDATAb00AB7YxDTTl",
        "saltKEYbcTcXHCBxtjD2",
        100_000,
        "$pbkdf2-sha512$100000$c2FsdEtFWWJjVGNYSENCeHRqRDI$WUJWsL1NbJ8hqH97pXcqeRoQ5hEGlPRDZc2UZw5X8a7NeX7x0QAZOHGQRMfwGAJml4Reua2X2X3jarh4aqtQlg"},
      {"passDATAb00AB7YxDTTlRH2dqxDx19GDxDV1zFMz7E6QVqKIzwOtMnlxQLttpE5",
        "saltKEYbcTcXHCBxtjD2PnBh44AIQ6XUOCESOhXpEp3HrcGMwbjzQKMSaf63IJe",
        100_000,
        "$pbkdf2-sha512$100000$c2FsdEtFWWJjVGNYSENCeHRqRDJQbkJoNDRBSVE2WFVPQ0VTT2hYcEVwM0hyY0dNd2JqelFLTVNhZjYzSUpl$B0R0AchXZuSu1YPeLmv1pnXqvk82GCgclWFvT8H9/m7LwcOYJ4nU/ZQdZYTvU0p4vTeuAlVdlFXo8In9tN.2uw"}
    ]
    |> check_checkpw
  end

  test "Comeonin Python passlib pbkdf2_sha512 tests" do
    [
      {"password",
        <<36, 196, 248, 159, 51, 166, 84, 170, 213, 250, 159, 211, 154, 83, 10, 193>>,
        19_000,
        "$pbkdf2-sha512$19000$JMT4nzOmVKrV.p/TmlMKwQ$jKbZHoPwUWBT08pjb/CnUZmFcB9JW4dsOzVkfi9X6Pdn5NXWeY.mhL1Bm4V9rjYL5ZfA32uh7Gl2gt5YQa/JCA"},
      {"p@$$w0rd",
        <<252, 159, 83, 202, 89, 107, 141, 17, 66, 200, 121, 239, 29, 163, 20, 34>>,
        19_000,
        "$pbkdf2-sha512$19000$/J9TyllrjRFCyHnvHaMUIg$AJ3Dr926ltK1sOZMZAAoT7EoR7R/Hp.G6Bt.4DFENiYayhVM/ZBPuqjFNhcE9NjTmceTmLnSqzfEQ8mafy49sw"},
      {"oh this is hard 2 guess",
        <<1, 96, 140, 17, 162, 84, 42, 165, 84, 42, 165, 244, 62, 71, 136, 177>>,
        19_000,
        "$pbkdf2-sha512$19000$AWCMEaJUKqVUKqX0PkeIsQ$F0xkzJUOKaH8pwAfEwLeZK2/li6CF3iEcpfoJ1XoExQUTStXCNVxE1sd1k0aeQlSFK6JnxJOjM18kZIdzNYkcQ"},
      {"even more difficult",
        <<215, 186, 87, 42, 133, 112, 14, 1, 160, 52, 38, 100, 44, 229, 92, 203>>,
        19_000,
        "$pbkdf2-sha512$19000$17pXKoVwDgGgNCZkLOVcyw$TEv9woSaVTsYHLxXnFbWO1oKrUGfUAljkLnqj8W/80BGaFbhccG8B9fZc05RoUo7JQvfcwsNee19g8GD5UxwHA"}
    ]
    |> check_checkpw
  end

  test "pbkdf2 dummy check" do
    assert Pbkdf2.dummy_checkpw == false
  end

  test "hashing and checking passwords" do
    hash_check_password("password", "passwor", "passwords", "pasword")
    hash_check_password("hard2guess", "ha rd2guess", "had2guess", "hardtoguess")
  end

  test "hashing and checking passwords with characters from the extended ascii set" do
    hash_check_password("aáåäeéêëoôö", "aáåäeéêëoö", "aáåeéêëoôö", "aáå äeéêëoôö")
    hash_check_password("aáåä eéêëoôö", "aáåä eéê ëoö", "a áåeé êëoôö", "aáå äeéêëoôö")
  end

  test "hashing and checking passwords with non-ascii characters" do
    hash_check_password("Сколько лет, сколько зим", "Сколько лет,сколько зим",
    "Сколько лет сколько зим", "Сколько лет, сколько")
    hash_check_password("สวัสดีครับ", "สวัดีครับ", "สวัสสดีครับ", "วัสดีครับ")
  end

  test "hashing and checking passwords with mixed characters" do
    hash_check_password("Я❤três☕ où☔", "Я❤tres☕ où☔", "Я❤três☕où☔", "Я❤três où☔")
  end

  test "gen_salt length of salt" do
    assert byte_size(Pbkdf2.gen_salt) == 12
    assert byte_size(Pbkdf2.gen_salt(32)) == 32
    assert byte_size(Pbkdf2.gen_salt(64)) == 64
  end

  test "wrong input to gen_salt" do
    assert_raise ArgumentError, "The salt is the wrong length.", fn ->
      Pbkdf2.gen_salt(11)
    end
    assert_raise ArgumentError, "The salt is the wrong length.", fn ->
      Pbkdf2.gen_salt(1025)
    end
  end

  test "trying to run hashpass without a salt" do
    assert_raise ArgumentError, "The salt is the wrong length.", fn ->
      Pbkdf2.hashpass("password", "")
    end
  end

  test "wrong input to hashpass" do
    assert_raise ArgumentError, "Wrong type. The salt needs to be a string.", fn ->
      Pbkdf2.hashpass("password", 'dontusecharlists')
    end
  end

  test "wrong input to checkpw" do
    assert_raise ArgumentError, "Wrong type. The password and hash need to be strings.", fn ->
      Pbkdf2.checkpw("password", '$pbkdf2-sha512$19000$JMT4nzOmVKrV.p/TmlMKwQ$jKbZHoPwUWBT08pjb/CnUZmFcB9JW4dsOzVkfi9X6Pdn5NXWeY.mhL1Bm4V9rjYL5ZfA32uh7Gl2gt5YQa/JCA')
    end
    assert_raise ArgumentError, "Wrong type. The password and hash need to be strings.", fn ->
      Pbkdf2.checkpw(nil, "$pbkdf2-sha512$19000$JMT4nzOmVKrV.p/TmlMKwQ$jKbZHoPwUWBT08pjb/CnUZmFcB9JW4dsOzVkfi9X6Pdn5NXWeY.mhL1Bm4V9rjYL5ZfA32uh7Gl2gt5YQa/JCA")
    end
  end
  
  test "return false if raise_on_unusable_pass is false" do
    assert Pbkdf2.checkpw("anypass", "!fLyg9p4OyCRCL5eQOxArW4dqEFqHJ6HoLTA54Agx", false) == false
  end
  
  test "raise if raise_on_unusable_pass is true and password format is not known" do
    assert_raise MatchError, fn ->
      Pbkdf2.checkpw("anypass", "!fLyg9p4OyCRCL5eQOxArW4dqEFqHJ6HoLTA54Agx")
    end
  end
end
