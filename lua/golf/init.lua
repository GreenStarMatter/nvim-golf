local dm = require("golf.diff_marker")
local ga = require("golf.golf_augmentor")
local sg = require("golf.golf_set_scene")

local M = {}
function M.main(opts)
	local run_mode = opts.fargs[1]
	if run_mode == "-g" then
		if #opts.fargs ~= 2 then
			print("Invalid number of args")
			print("Input should be of the form: -g /path/to/file")
			print("Game not started")
			return
		end
		local file_path = opts.fargs[2]
		ga.augment_file(file_path, 0.4)
		sg.set_golf(file_path)
		dm.mark_differences(file_path)
	elseif run_mode == "-c" then
		vim.cmd("save GOLF_FILE.txt")
		local golf_file_name = _G.__plugin_meta and _G.__plugin_meta["golf_file_name"]
		if golf_file_name then
			dm.mark_differences(golf_file_name)
		else
			print("Buffer or file not found")
		end
		local golf_start_time = _G.__plugin_meta and _G.__plugin_meta["golf_start_time"]
		if golf_start_time then
			print("Seconds Elapsed: " .. tonumber(os.time()) - tonumber(golf_start_time))
		else
			print("Time Buffer not found: Playing for the love of the game")
		end
	else
		print("Golf Run Mode not recognized")
		print("Expected -g or -c, received: " .. run_mode)
	end
end
return M
