PJ_ERROR_WRAPPING = PJ_ERROR_WRAPPING or {}
if PJ_ERROR_WRAPPING.is_wrapping_completed then return end

PJ_ERROR_WRAPPING.is_wrapping_completed = true

if campaign_manager then
	local orig_ftc = campaign_manager.add_first_tick_callback

	campaign_manager.add_first_tick_callback = function(self, fun)
		return orig_ftc(self, function()
			local success, result = pcall(fun)
			if not success then
				out("BIG FAT SCRIPT ERROR")
				out(tostring(result))
				out(tostring(debug.traceback()))
				return false
			end
			return result
		end)
	end

	local orig_cb = campaign_manager.callback

	campaign_manager.callback = function(self, fun, ...)
		local new_fun = function(...)
			local success, result = pcall(fun, ...)
			if not success then
					out("BIG FAT SCRIPT ERROR")
					out(tostring(result))
					out(tostring(debug.traceback()))
					return false
			end
			return result
		end

		orig_cb(self, new_fun, ...)
	end
end

local orig_al = core.add_listener

core.add_listener = function(self, listener_name, event_name, conditional, callback, ...)
	local new_conditional =
			type(conditional) == "function"
			and function(...)
							local success, result = pcall(conditional, ...)
							if not success then
									out("BIG FAT SCRIPT ERROR")
									out(tostring(result))
									out(tostring(debug.traceback()))
									return false
							end
							return result
					end
			or conditional

	local new_callback = function(...)
		local success, result = pcall(callback, ...)
		if not success then
			out("BIG FAT SCRIPT ERROR")
			out(tostring(result))
			out(tostring(debug.traceback()))
			return false
		end
		return result
	end
	return orig_al(self, listener_name, event_name, new_conditional, new_callback, ...)
end
