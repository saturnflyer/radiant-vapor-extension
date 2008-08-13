With Vapor you can create URLs that will point users to other locations.

## How It Works

Vapor manages the redirection in objects called flow meters. In each flow meter you'll need to have 
the `catch_url` (which is the URL that will be the false page) and the `redirect_url` (which is an 
actual page on your site). By default the `status` is set to '307' (which is 'Temporarily Moved'), 
but currently the status feature is not implemented.

You may also set the redirect_url to an external site beginning with 'http://'.

## Where and When

Vapor is a simple solution to allow your users to manage and edit URL redirection themselves. Long-term 
redirects might be better served by addressing them outside of the application by handling the redirect 
with your web or application server.

In order to prevent database access with each request to the site, Vapor loads all URL directives into
memory when the extension is initialized, when a new flow meter is created, and when a flow meter is
destroyed.