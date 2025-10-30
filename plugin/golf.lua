-- This plugin is a little game called NeoVim Golf
-- The idea is to practice NeoVim file editing on cheat sheets or common files
-- The user will start a game with :Golf -g /path/to/file.txt (any extension is fine)
-- The user should then go through the created file and fix the changes made
-- Once the new file on the right resembles the source on the left, then the user should check
-- The user will check a game with :Golf -c
-- There is no true "termination" of the game, this is just a fun widget for now
-- That being said, the target file will be marked with x's on mismatch lines and checks on match lines
-- If the check is completely successful, then a "win" message will be printed
vim.api.nvim_create_user_command("Golf", function(opts)
	require("golf").main(opts)
end, { nargs = "+" })
