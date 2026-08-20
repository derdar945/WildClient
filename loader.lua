local HttpService = game:GetService("HttpService")

local URL = "https://raw.githubusercontent.com/derdar945/WildClient/main/solara_ui.lua"

local function fetch(url)
	local ok, result = pcall(function()
		return HttpService:GetAsync(url)
	end)
	if ok and type(result) == "string" then
		return result
	end

	if http and http.get then
		local r = pcall(http.get, url)
		if r then
			local body = r and r.Body or r
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

	error("Не удалось загрузить скрипт по ссылке")
end

local code = fetch(URL)

local func, err = loadstring(code, "WildClient")
if not func then
	error("Ошибка компиляции скрипта: " .. tostring(err))
end

func()