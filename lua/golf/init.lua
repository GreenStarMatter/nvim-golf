local dm = require("golf.diff_marker")
local ga = require("golf.golf_augmentor")
local sg = require("golf.golf_set_scene")

local M = {}
-- This is the main logic of the golf game
-- There are currently two run modes -g and -c
-- First the user is expected to start a game
-- This can be done by :Golf -g /path/to/file.txt
-- This mode sets the game, augments the file, and then runs a diff check
-- Presumably after some changes have been made, the user can run a check
-- This can be done by :Golf -c
-- This will run the check logic and remark the target file with x's and checks
-- There is no true "termination" of the game, this is just a fun widget for now
function M.main(opts)
	local golf_data_dir = vim.fn.stdpath("data") .. "/nvim-golf"
	vim.fn.mkdir(golf_data_dir, "p")
	local play_file_path = golf_data_dir .. "/GOLF_FILE.txt"
	local run_mode = opts.fargs[1]
	if run_mode == "-g" then
		if #opts.fargs ~= 2 then
			print("Invalid number of args")
			print("Input should be of the form: -g /path/to/file")
			print("Game not started")
			return
		end
		if vim.fn.filereadable(opts.fargs[2]) ~= 1 then
			print("File does not exist: " .. opts.fargs[2])
			print("Not starting game")
			return
		end
		if #vim.api.nvim_list_wins() ~= 1 then
			print("Please only start this game with 1 window open")
			print("Game not started")
			return
		end
		local file_path = opts.fargs[2]
		ga.augment_file(file_path, play_file_path, 0.4)
		sg.set_golf(file_path, play_file_path)
		dm.mark_differences(file_path, play_file_path)
	elseif run_mode == "-c" then
		local golf_game_status = _G.__plugin_meta and _G.__plugin_meta["golf_game_status"]
		if golf_game_status ~= "Game on!" then
			print("No game set, first run :Golf -g /path/to/file.txt")
			return
		end
		local golf_file_name = _G.__plugin_meta and _G.__plugin_meta["golf_file_name"]
		if vim.fn.filereadable(golf_file_name) ~= 1 then
			print("Previous File does not exist: " .. golf_file_name)
			print("Game is now invalid, start a new one")
			return
		end
		vim.cmd("save " .. play_file_path)
		if golf_file_name then
			dm.mark_differences(golf_file_name, play_file_path)
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
