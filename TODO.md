# TODO

## Cache Invalidator Proxy

The main known drawback from this library (and pretty much everyone out there) is: Cache Invalidation.

Certainly, you could have the parent application hit the database every single time for every single request to look up the permissions for current_user, but that's a lot of extraneous work which doesn't need to happen. The underlying questions are:

> How often does a Role change?
> How often does a User have their roles modified?
> If we supported caching, how do we know when to invalidate the cache?
> How do we invalidate ALL the caches when dealing with a distributed system? (because requests just get tossed off to any old server)

My solution is to have no immediate solution. This is not a problem that Jak attempts to solve. However, I would like to have some kind of CacheProxy singleton available to where something such as:

```ruby
Jak.cache_proxy.invalidate!
```

would be supported. That would use some hand-waving and internet magic to make all the caches invalidate. Given this strategy, we could store a *cached copy* of a User's ability file, serve that up, and when Jak determines that the current data is invalid, it would then be possible to sync up and make everyone happy.

My hope is to just get some kind of CacheProxy stubbed out.

## Extraneous Specs

I need to add many more value-adding specs to the code base. Ideally, the focus would be on Ability permissions and making sure that every kind of query is scoped to the Tenant / restrictions.

## MonkeyPatch PORO

Jak performs a lot of monkey-patching inside `engine.rb`, and while that works, it would be great to have a declarative PORO (plain-old-ruby-object) behind that so as to be able to improve specs.

## Docker Testing Container

It would be nice to have different docker profiles for `development` and `test` so that `test` would just run the specs. The idea being that you would hook up the `test` profile to some kind of continuous integration server.

## YouTube / Demo App

It would be nice to have a YouTube series where I take a standard Rails 5.2? application and add `Jak` to it. I could show off things like multi-tenancy, constraint restrictions, etc.


## Postman collection

It would be nice to include an export json dump of a Postman collection so it shows all the endpoints available in the engine.


## Initializer Profiles

have an intializer for the development environment, and one for the test environment so you can ensure they each work independently of each other.
