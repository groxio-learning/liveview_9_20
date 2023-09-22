# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Game.Repo.insert!(%Game.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Game.Library

Library.create_reading(%{
  name: "Airplane",
  text: "I picked the wrong week to stop sniffing glue.",
  steps: 3
})

Library.create_reading(%{
  name: "The Hobbit",
  text: "It's a dangerous business, Frodo, going out your door. You step onto the road, and if you don't keep your feet, there's no knowing where you might be swept off to.",
  steps: 5
})

Library.create_reading(%{
  name: "Fast and the Furious",
  text: "There is more to life than increasing its speed",
  steps: 3
})

Library.create_reading(%{
  name: "Star Wars",
  text: "Do or do not, there is no try.",
  steps: 3
})
