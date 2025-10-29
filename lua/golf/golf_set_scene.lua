local M = {}

M.set_golf = function(file_path)
  local view_original_file_command = 'view ' .. file_path
  _G.__plugin_meta = _G.__plugin_meta or {}
  _G.__plugin_meta['golf_file_name'] = file_path
  _G.__plugin_meta['golf_start_time'] = os.time()
  vim.cmd(view_original_file_command)
  vim.cmd 'set nomodifiable'
  vim.cmd 'vsplit'
  vim.cmd 'edit GOLF_FILE.txt'
  vim.cmd 'set modifiable'
end
return M
