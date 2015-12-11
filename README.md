# ExDjango

[![Travis](https://img.shields.io/travis/nicksanders/exdjango.svg?style=flat-square)](https://travis-ci.org/nicksanders/exdjango)
[![Hex.pm](https://img.shields.io/hexpm/v/exdjango.svg?style=flat-square)](https://hex.pm/packages/exdjango)
[![Hex.pm](https://img.shields.io/hexpm/dt/exdjango.svg?style=flat-square)](https://hex.pm/packages/exdjango)

An elixir library for working with django

Warning: This is Alpha software and subject to breaking changes.

## Features

* Django cookie-based sessions
* Django redis cache sessions
* Django pbkdf2_sha256 passwords

## Installation

Add ex_django to your `mix.exs` dependencies other dependencies are optional depending on what features you want to use.

```elixir
defp deps do
[ {:exdjango, "~> 0.1.1"} ]
end
```

If you need cookie-based sessions you need to add poison

```elixir
{:poison, "~> 1.5.0"},
```

If you need redis sessions you need to add poison and exredis

```elixir
{:poison, "~> 1.5.0"},
{:exredis, "~> 0.2.0"},
```

If you need to read/write django passwords you need to add comeonin

```elixir
{:comeonin, "~> 1.6"},
```

## Django sessions
Add secret_key to config.exs and add either Cookie or Redis to endpoint.ex Plug config

```elixir
# config.exs  
config :exdjango, :config,
  secret_key: "django-secret-key"
```
and

```elixir
# endpoint.ex  
plug Plug.Session,
  store: ExDjango.Session.Cookie,
  key: "sessionid"
```

or

```elixir
# endpoint.ex  
plug Plug.Session,
  store: ExDjango.Session.Redis,
  key: "sessionid"
```

get/set user id ("_auth_user_id" from django session)

```elixir
conn
 |> ExDjango.Session.put_user(99)

conn
 |> ExDjango.Session.get_user()   
```


## Django passwords

```elixir
ExDjango.Pbkdf2.checkpw(password, user.password)

changeset
|> put_change(:password, ExDjango.Pbkdf2.hashpwsalt(changeset.params["plaintext_password"]))
|> repo.insert()
```
