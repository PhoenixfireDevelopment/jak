# MIDDLEWARE

Middleware module will load the set of configured middleware to run in the order that they have been added.

## Proxy (including callbacks)

Originally, I intended this to be used for which callbacks and methods to run as part of the Jak::Engine initialization sequence. I think later on it was altered and mixed up in that, it was used to prevent the `development` DSL profile from

* Loading when running the `test` specs
* Loading when the generators were being invoked

As it currently stands, it has become an impediment because I can't test separate "DSL Profiles" right now.

## Autoloader (concerns, declarative format!) / Engine PORO

This is designed to `autoload` "concerns" (i.e. fancy monkey patching) onto the base classes that we care about. I want this to be written in a declarative fashion so that I can test that:

* Expected monkey-patching is happening
* Extending classes and code is done in the proper sequence

## Jak Hooks (from app into Jak)

I want to add a way for the dummy app (i.e. the end-programmer app) to tie into the initialization and life-cycle process of Jak.

## Profile DSL Loader

Instead of having an initializer file which defines the DSL at boot time (which would happen in ANY environment), I want to separate it out in a similar fashion to Rails environment files (development.rb / test.rb / production.rb). I want to go one step further so that I can test multiple "DSL Profiles" to ensure that "it only works because this is the only way we use and test this currently".

## Permission Creator Thing / Invokers

I want to move the logic for creating permissions and for managing invoker monkey patching out of constraint manager.
