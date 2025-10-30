local M = {}
-- This function marks the differences between the source file and target file
-- It should display a red x on lines that are different in the target file
-- It should display a check on lines in the target file that match the source
-- If there are no mismatches, then a "win" state is achieved
-- There is no official "termination" of the game, as this is just a widget to help me learn
M.mark_differences = function(file_to_golf, golf_game_file)
	local first_file = vim.fn.readfile(file_to_golf)
	local second_file = vim.fn.readfile(golf_game_file)
	local mismatch_counter = 0
	vim.fn.sign_define("GolfMarker", { text = "X", texthl = "ErrorMsg" })
	vim.fn.sign_define("GolfCheck", { text = "✓", texthl = "GreenText" })
	for line_number = 1, #first_file do
		if line_number > #second_file then
			vim.fn.sign_place(0, "golf_group", "GolfMarker", vim.api.nvim_get_current_buf(), { lnum = line_number })
		elseif first_file[line_number] ~= second_file[line_number] then
			vim.fn.sign_place(0, "golf_group", "GolfMarker", vim.api.nvim_get_current_buf(), { lnum = line_number })
			mismatch_counter = mismatch_counter + 1
		else
			vim.fn.sign_place(0, "golf_group", "GolfCheck", vim.api.nvim_get_current_buf(), { lnum = line_number })
		end
		local line_difference = #second_file - #first_file
		if line_difference > 0 then
			for second_line_number = #second_file - line_difference, #second_file do
				vim.fn.sign_place(
					0,
					"golf_group",
					"GolfMarker",
					vim.api.nvim_get_current_buf(),
					{ lnum = second_line_number }
				)
				mismatch_counter = mismatch_counter + 1
			end
		end
	end
	if mismatch_counter == 0 then
		print("You did it!")
	else
		print("Still errors left to fix: " .. mismatch_counter)
	end
end

return M
