With Vapor you can create URLs that will point users to other locations. These are called flow meters.

In each flow meter you'll need to have the `catch_url` (which is the URL that will be the false page) and the `redirect_url` (which is an actual page on your site). By default the `status` is set to '307' (which is 'Temporarily Moved').

Long-term redirects might be better served by addressing them outside of the application by handling the redirect with your web or application server. 