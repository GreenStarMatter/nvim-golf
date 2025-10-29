local M = {}

M.augment_file = function(incoming_file, entropy_level)
  math.randomseed(os.time())
  local entropy_funcs = {}
  local function delete_line()
    print 'delete line'
  end
  local function swap_word()
    print 'swap word'
  end
  local function delete_chunk(line)
    local index_a = math.random(1, #line)
    local index_b = math.random(1, #line)
    local beginning_line = line:sub(1, math.min(index_a, index_b))
    local end_line = line:sub(math.max(index_a, index_b), #line)
    local new_line = beginning_line .. end_line
    return new_line
  end
  local function random_letter(line)
    local new_line = ''
    for letter_index = 1, #line do
      local random_replace_chance = math.random()
      if random_replace_chance < 0.98 then
        new_line = new_line .. line:sub(letter_index, letter_index)
      else
        new_line = new_line .. string.char(math.random(65, 90))
      end
    end
    return new_line
  end
  local delete_line_entropy = 0.6
  local delete_chunk_entropy = 0.4
  local swap_word_entropy = 0.1
  local random_letter_entropy = 0.4

  entropy_funcs[delete_line] = delete_line_entropy
  entropy_funcs[delete_chunk] = delete_chunk_entropy
  entropy_funcs[swap_word] = swap_word_entropy
  entropy_funcs[random_letter] = random_letter_entropy

  local file_to_augment = vim.fn.readfile(incoming_file)
  local augmented_golf_file = {}
  for _, line in ipairs(file_to_augment) do
    local current_budget = entropy_level
    repeat
      entropy_level = entropy_level + 1
      local random_replace_choice = math.random()
      if random_replace_choice < 0.5 then
        table.insert(augmented_golf_file, random_letter(line))
      else
        table.insert(augmented_golf_file, delete_chunk(line))
      end
      print 'entropy test'
    until entropy_level > 1
  end
  vim.fn.writefile(augmented_golf_file, 'GOLF_FILE.txt')
end

return M
