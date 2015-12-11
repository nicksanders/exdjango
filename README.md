# ExDjango [![Build Status](https://travis-ci.org/nicksanders/exdjango.svg?branch=master)](https://travis-ci.org/nicksanders/exdjango)

A few elixir libraries for working with django

## Features

* Django cookie-based sessions
* Django redis cache sessions
* Django pbkdf2_sha256 passwords

## Installation

Add ex_django to your `mix.exs` dependencies other dependencies are optional depending on what features you want to use.

```elixir
defp deps do
[ {:ex_django, "~> 0.1.0"} ]
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

```elixir
# endpoint.ex  
plug Plug.Session,
    store: ExDjango.Session.Cookie,
    key: "sessionid",
    secret_key: "django-secret-key"
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
