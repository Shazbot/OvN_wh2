local orig_modlog = ModLog
ModLog = function(msg, ...)
	if msg and is_string(msg) then
		if string.match(msg, "error is: cannot open .+: No such file or directory.") then
			orig_modlog("THIS IS NOT AN ACTUAL ERROR, IT'S COMPLAINING ABOUT A SCRIPT IN A SUBFOLDER")
			orig_modlog("THIS IS NOT AN ACTUAL ERROR, IT'S COMPLAINING ABOUT A SCRIPT IN A SUBFOLDER")
			orig_modlog("THIS IS NOT AN ACTUAL ERROR, IT'S COMPLAINING ABOUT A SCRIPT IN A SUBFOLDER")
            orig_modlog("YOU CAN IGNORE THIS \"ERROR\", IT WON'T CAUSE ANY ISSUES")
		end
	end

	return orig_modlog(msg, ...)
end