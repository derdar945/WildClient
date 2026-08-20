local HttpService = game:GetService("HttpService")

local OWNER = "derdar945"
local REPO = "WildClient"
local BRANCH = "main"

local Cache = {}

local function urlsFor(path)
	local ts = tostring(os.time())
	return {
		"https://raw.githubusercontent.com/" .. OWNER .. "/" .. REPO .. "/" .. BRANCH .. "/src/" .. path .. ".lua?v=" .. ts,
		"https://cdn.jsdelivr.net/gh/" .. OWNER .. "/" .. REPO .. "@" .. BRANCH .. "/src/" .. path .. ".lua",
		"https://github.com/" .. OWNER .. "/" .. REPO .. "/raw/" .. BRANCH .. "/src/" .. path .. ".lua",
	}
end

local function fetch(url)
	local ok, result = pcall(function()
		return HttpService:GetAsync(url)
	end)
	if ok and type(result) == "string" and result:find("return") then
		return result
	end

	if http and http.get then
		local ok2, body = pcall(http.get, url)
		if ok2 and body then
			body = type(body) == "string" and body or body.Body
			if type(body) == "string" and body:find("return") then
				return body
			end
		end
	end
	if syn and syn.request then
		local r = syn.request({ Url = url, Method = "GET" })
		if r and r.StatusCode == 200 and r.Body and r.Body:find("return") then
			return r.Body
		end
	end
	if request then
		local r = request({ Url = url, Method = "GET" })
		if r and r.StatusCode == 200 and r.Body and r.Body:find("return") then
			return r.Body
		end
	end
	return nil
end

local function getModule(path)
	if Cache[path] ~= nil then
		return Cache[path]
	end
	local code = nil
	for _, url in ipairs(urlsFor(path)) do
		code = fetch(url)
		if code then
			break
		end
	end
	if not code then
		error("Не удалось загрузить модуль: " .. path)
	end
	local fn, err = loadstring(code, path)
	if not fn then
		error("Ошибка компиляции модуля " .. path .. ": " .. tostring(err))
	end
	Cache[path] = fn()
	return Cache[path]
end

(getgenv and getgenv() or _G).getModule = getModule

getModule("main")