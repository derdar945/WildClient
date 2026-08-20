local HttpService = game:GetService("HttpService")

local OWNER = "derdar945"
local REPO = "WildClient"
local FILE = "solara_ui.lua"

local CANDIDATES = {
	"https://raw.githubusercontent.com/" .. OWNER .. "/" .. REPO .. "/main/" .. FILE .. "?v=" .. tostring(os.time()),
	"https://cdn.jsdelivr.net/gh/" .. OWNER .. "/" .. REPO .. "@main/" .. FILE,
	"https://github.com/" .. OWNER .. "/" .. REPO .. "/raw/main/" .. FILE,
}

local function fetch(url)
	local ok, result = pcall(function()
		return HttpService:GetAsync(url)
	end)
	if ok and type(result) == "string" and result:find("WildClient") then
		return result
	end

	if http and http.get then
		local ok2, body = pcall(http.get, url)
		if ok2 and body then
			body = type(body) == "string" and body or body.Body
			if type(body) == "string" and body:find("WildClient") then
				return body
			end
		end
	end
	if syn and syn.request then
		local r = syn.request({ Url = url, Method = "GET" })
		if r and r.StatusCode == 200 and r.Body and r.Body:find("WildClient") then
			return r.Body
		end
	end
	if request then
		local r = request({ Url = url, Method = "GET" })
		if r and r.StatusCode == 200 and r.Body and r.Body:find("WildClient") then
			return r.Body
		end
	end
	return nil
end

local code = nil
for _, url in ipairs(CANDIDATES) do
	code = fetch(url)
	if code then
		break
	end
end
if not code then
	error("Не удалось загрузить скрипт с GitHub")
end

local func, err = loadstring(code, "WildClient")
if not func then
	error("Ошибка компиляции скрипта: " .. tostring(err))
end

func()