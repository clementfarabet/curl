-- Libs
require 'sys'
local surl = require 'socket.url'
local json = require 'cjson'

-- CURL Library
local curl = {}

-- Format options:
local function formatUrl(url,options)
   -- Format query:
   local query 
   if options and next(options) then
      query = {}
      for k,v in pairs(options) do
         v = tostring(v)
         table.insert(query, surl.escape(k) .. '=' .. surl.escape(v))
      end
      query = table.concat(query,'&')
   end

   -- Create full URL:
   if query then url = url .. '?' .. query end
   return url
end

-- Format form:
local function formatForm(options)
   -- Format form:
   local form = {}
   if options and next(options) then
      for k,v in pairs(options) do
         v = tostring(v)
         table.insert(form, ' -F "' .. k .. '=' .. v .. '"')
      end
   end
   form = table.concat(form,' ')
   return form
end

-- GET
function curl.get(args,query,format)
   -- Args:
   if type(args) == 'string' then
      args = {
         url = args,
         query = query,
         format = format
      }
   end

   -- URL:
   local url = args.url or (args.host .. (args.path or '/'))
   local query = args.query
   local format = args.format or 'raw' -- or 'json'
   local cookie = (args.cookie and ('-b ' .. args.cookie)) or ''
   local auth = args.auth
   local verbose = args.verbose

   -- Basic auth
   if auth then
      auth = '--user ' .. auth.user .. ':' .. auth.password
   else
      auth = ''
   end

   -- Format URL:
   local url = formatUrl(url,query)

   -- GET:
   local cmd = string.format('curl -ks %s %s "%s"', auth, cookie, url)
   if verbose then print(cmd) end
   local res = sys.execute(cmd)

   -- Format?
   if format == 'json' then
      res = json.decode(res)
   end

   -- Return res
   return res
end

-- POST
function curl.post(args,form,format)
   -- Args:
   if type(args) == 'string' then
      args = {
         url = args,
         form = form,
         format = format,
      }
   end

   -- URL:
   local url = args.url or (args.host .. (args.path or '/'))
   local form = args.form or error('please provide field: form')
   local format = args.format or 'raw' -- or 'json'
   local cookie = (args.cookie and ('-b ' .. args.cookie)) or ''
   local saveCookie = (args.saveCookie and ('-c ' .. args.saveCookie)) or ''
   local auth = args.auth
   local verbose = args.verbose
   
   -- Basic auth
   if auth then
      auth = '--user ' .. auth.user .. ':' .. auth.password
   else
      auth = ''
   end

   -- Format URL:
   form = formatForm(form)

   -- GET:
   local cmd = string.format('curl -ks %s %s %s "%s" %s', auth, saveCookie, cookie, url, form)
   if verbose then print(cmd) end
   local res = sys.execute(cmd)

   -- Format?
   if format == 'json' then
      res = json.decode(res)
   end

   -- Return res
   return res
end

-- Return lib
return curl
