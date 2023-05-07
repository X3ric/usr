-- Save read only files
function savefile()
	if vim.bo.readonly then
		vim.cmd(':silent w !pkexec tee % >/dev/null')
		vim.cmd(':edit!')
	else
		vim.cmd(':w')
	end
end
function compacttelescope(telescope_func, options)
    options = options or {}
    options.layout_strategy = "bottom_pane"
    options.layout_config = {
        height = 10,
        prompt_position = "bottom",
        width = 1.0
    }
    options.previewer = false
    telescope_func(options)
end
function compacttelescopepreview(telescope_func, options)
    options = options or {}
    options.layout_strategy = "vertical"
    options.layout_config = {
        height = 0.55,
        prompt_position = "bottom",
        width = 0.25
    }
    options.previewer = true
    telescope_func(options)
end
function findfiles()
	local options = {}
	options.layout_strategy = "vertical"
	options.layout_config = {
		width = 0.25,
	}
	options.hidden = true
	require('telescope.builtin').find_files(options)
end
-- Toggle truncated lines
vim.api.nvim_exec([[
function! ToggleWrap()
    if &wrap
        setlocal nowrap
    else
        setlocal wrap
    endif
endfunction
]], false)
-- Toggle line numbers
vim.api.nvim_exec([[
let g:linenumber_state = 'number'
function! ToggleLineNumbers()
    if g:linenumber_state == 'number'
        set relativenumber
        let g:linenumber_state = 'relativenumber'
    elseif g:linenumber_state == 'relativenumber'
        set nonumber
        set norelativenumber
        let g:linenumber_state = 'none'
    else
        set number
        let g:linenumber_state = 'number'
    endif
endfunction
]], false)
-- Compile command
local function find_dir_with_makefile()
    local current_dir = vim.fn.expand('%:p:h')
    while current_dir ~= '/' do
      if vim.fn.filereadable(current_dir .. '/Makefile') ~= 0 then
        return current_dir
      end
      current_dir = vim.fn.fnamemodify(current_dir, ':h')
    end
  end
  local function run_make_command()
    local makefile_dir = find_dir_with_makefile()
    if makefile_dir then
      local Terminal = require('toggleterm.terminal').Terminal
      local make = Terminal:new({
        cmd = "make run",
        dir = makefile_dir,
        close_on_exit = false,
        on_open = function(term)
          vim.cmd("startinsert!")
        end,
        on_close = function(term)
          vim.cmd("Closing terminal")
        end,
      })
      make:toggle()
    else
      print("No Makefile found in any parent directories.")
    end
  end
  vim.api.nvim_create_user_command("Compile", run_make_command, {})
