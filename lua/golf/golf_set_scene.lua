local M = {}
-- This function sets the game
-- It gets the file at the user designated path
-- It then sets the game view and marks the files modify states
-- The original source file is protected
-- The new target file is set as modifiable
-- The source file path and some meta data is stored in a global buffer
-- This buffer save is done to calc time elapsed and be able to access the
-- source file for future diff checks
M.set_golf = function(file_path, golf_file_path)
	local view_original_file_command = "view " .. file_path
	_G.__plugin_meta = _G.__plugin_meta or {}
	_G.__plugin_meta["golf_file_name"] = file_path
	_G.__plugin_meta["golf_start_time"] = os.time()
	_G.__plugin_meta["golf_game_status"] = "Game on!"
	vim.cmd(view_original_file_command)
	vim.cmd("set nomodifiable")
	vim.cmd("vsplit")
	vim.cmd("edit " .. golf_file_path)
	vim.cmd("set modifiable")
end
return M
