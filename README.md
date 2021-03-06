CURL
====

A simple interface to CURL.

Provides two functions: _get_ and _post_.

_get_:

```lua
-- load lib:
curl = require 'curl'

-- getting random pages:
res = curl.get('http://www.google.com')

-- with query:
res = curl.get('http://www.google.com', {safe='off', output='search', oq='test'})

-- complete API:
res = curl.get{
    host = 'http://blogname.blogspot.com',
    path = '/feeds/posts/default',
    query = {
        alt = 'json'
    },
    format = 'json' -- parses the output: json -> Lua table
}

-- Getting an image, and decoding it:
img = curl.get('http://www.webstandards.org/files/acid2/reference.png')
require('graphicsmagick').Image():fromString(img):show()
```

_post_:

```lua
-- post has the same API, with a form parameter (instead of query)
res = curl.post{
    host = 'http://myserver.com',
    path = '/',
    form = {
        username = 'bob',
        password = 'key',
        somefiletoupload = '@/local/path/to/file.jpg'
    }
}
```

