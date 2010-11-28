OmniAuth Testing
================

Aids integration testing of OmniAuth functionality in your app by providing fake
responses through FakeWeb for various providers such as Twitter, Facebook,
OpenID, etc.

Installation & Usage
--------------------

To install, add this to the Gemfile `test` group and run `bundle`:

    gem 'oa-testing'

Usage is very simple, as `oa-testing` automatically registers the appropriate
fake responses when you add a provider to the middleware stack.

Assuming you are using Cucumber, this is how a snippet of the "User signs up"
feature (or whatever it is called) might look:

    When I follow "Sign up using Twitter."
    And I have authorized the app to read my info

The first step might take the user to `/auth/twitter`. The definition of the
second step might look like this:

    When /^I have authorized the app to read my info$/ do
      visit '/auth/twitter/callback'
    end

This approach results in the closest mirroring of normal, non-testing behavior,
since it allows OmniAuth to work through both the *request phase* and *access
phase*, as opposed to jumping directly to the latter &mdash; also known as "short
circuiting".

Don't "short circuit"
---------------------

If you're using OmniAuth through Devise you might have noticed that [the
suggested way to avoid requests to providers](https://github.com/plataformatec/devise/wiki/OmniAuth:-Testing)
is to "short circuit" links to them, i.e. to link directly to the callback.
However, I do not recommend this approach for the simple reason that it doesn't
work in some cases. For instance, this is what the process of authorizing
through Twitter looks like:

  1. The user clicks the link for authorizing through Twitter (e.g.
     `/auth/twitter`), after which the *request phase* begins.
  2. OmniAuth fetches a *request token* from Twitter which it stores in the
     current session.
  3. OmniAuth redirects to the *authorize URL* (e.g. `https://api.twitter.com/oauth/authenticate?oauth_token=...`)
     where `oauth_token` is the request token.
  4. The user signs in to Twitter if needed and authorizes the app if he haven't
     already.
  5. Twitter redirects back to the app (e.g. to `/auth/twitter/callback`),
     triggering the *callback phase*.
  6. OmniAuth fetches an *access token* from Twitter based on the previously
     stored request token.
  7. OmniAuth uses the access token to retrieve the user information.

There are uncovered details, but the description above should be sufficient to
make my point: By linking directly to the callback you're effectively skipping
the request phase, which in the case of Twitter results in OmniAuth trying to
use a session value that hasn't actually been set.

Supported Providers
-------------------

At the moment only Twitter is supported. I'm currently working on an app that
uses OmniAuth, and I'm going through Twitter, Facebook, Google Apps, and OpenID
one by one, trying to figure out how to integration test sign-up and sign-in
for each of them, so hopefully `oa-testing` will eventually support all of
those. Naturally, you are very welcome to contribute support for other providers
if you happen to know the appropriate fake responses.

Contributing
------------

  1. Fork the project on GitHub.
  2. Push your changes to a topic branch of your fork.
  3. Send me a pull request.

Don't forget that tests are required for a pull request to be accepted!

Copyright
---------

Copyright &copy; 2010 David Trasbo of Insane Innovation &mdash; See `LICENSE` for more
detail.