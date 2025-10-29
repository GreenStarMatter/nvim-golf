vim.api.nvim_create_user_command("Golf", function(opts)
	require("golf").main(opts)
end, { nargs = "+" })
