
-- load lib
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
print(res)

-- Getting an image, and decoding it:
img = curl.get('http://www.webstandards.org/files/acid2/reference.png')
require('graphicsmagick').Image():fromString(img):show()
