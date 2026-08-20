local HttpService = game:GetService("HttpService")

local OWNER = "derdar945"
local REPO = "WildClient"
local FILE = "solara_ui.lua"

local function rawUrl(ref)
	return "https://raw.githubusercontent.com/" .. OWNER .. "/" .. REPO .. "/" .. ref .. "/" .. FILE
end

local function fetch(url)
	local ok, result = pcall(function()
		return HttpService:GetAsync(url)
	end)
	if ok and type(result) == "string" then
		return result
	end

	if http and http.get then
		local ok2, body = pcall(http.get, url)
		if ok2 and body then
			body = type(body) == "string" and body or body.Body
			if type(body) == "string" then
				return body
			end
		end
	end
	if syn and syn.request then
		local r = syn.request({ Url = url, Method = "GET" })
		if r and r.StatusCode == 200 and r.Body then
			return r.Body
		end
	end
	if request then
		local r = request({ Url = url, Method = "GET" })
		if r and r.StatusCode == 200 and r.Body then
			return r.Body
		end
	end
	return nil
end

local function latestCommit()
	local ok, json = pcall(function()
		return HttpService:GetAsync(
			"https://api.github.com/repos/" .. OWNER .. "/" .. REPO .. "/commits/main",
			false,
			{ ["User-Agent"] = "WildClient" }
		)
	end)
	if not ok then
		return nil
	end
	local ok2, data = pcall(HttpService.JSONDecode, HttpService, json)
	if not ok2 or not data or not data.sha then
		return nil
	end
	return data.sha
end

local sha = latestCommit()

local code = nil
if sha then
	code = fetch(rawUrl(sha))
end
if not code then
	code = fetch(rawUrl("main") .. "?ts=" .. tostring(os.time()))
end
if not code then
	error("Не удалось загрузить скрипт с GitHub")
end

local func, err = loadstring(code, "WildClient")
if not func then
	error("Ошибка компиляции скрипта: " .. tostring(err))
end

func()