With Vapor you can create URLs that will point users to other locations.

## How It Works

Vapor manages the redirection in objects called flow meters. In each flow meter you'll need to have 
the `catch_url` (which is the URL that will be the false page) and the `redirect_url` (which is an 
actual page on your site). By default the `status` is set to '307 Temporarily Moved'.

You may also set the redirect_url to an external site beginning with 'http://'.

## What to Catch

You have some options with Vapor. 

By default, each flow meter that you create will only match against
the exact url. This means that a `catch_url` of `/articles` will not redirect for a url of 
`/articles/2008/09/19/third-post/`.

To change this, you may set `Radiant::Config['vapor.use_regexp'] = 'true'`. This will catch any url
that _begins_ with the given `catch_url`. The `catch_url` in this case is a regular expression, and
the `redirect_url` may contain substitution variables like $0 (the matched string), $1 (the first
match
group), and so on.

You may also nest your flow meters with this setting. Setting `/about` to redirect to `/us` and `/about/team` to 
redirect to `/team` will work. When the `vapor.use_regexp` option is set, the flow meters will be
compared to the requests in reverse alphabetical order so that longer `catch_url`s will be processed
first.

## Where and When

Vapor is a simple solution to allow your users to manage and edit URL redirection themselves. Long-term 
redirects might be better served by addressing them outside of the application by handling the redirect 
with your web or application server.

In order to prevent database access with each request to the site, Vapor loads all URL directives into
memory when the extension is initialized, when a new flow meter is created, and when a flow meter is
destroyed.