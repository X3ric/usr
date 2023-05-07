local M = {}

M.attach = function(client, buffer)
  local opts = { noremap = true, silent = true }
  local map = vim.api.nvim_buf_set_keymap
  map(buffer, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", vim.tbl_extend('force', opts, { desc = 'Cursor info' }))
  map(buffer, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", vim.tbl_extend('force', opts, { desc = 'Diagnostic' }))
  map(buffer, "n", "gL", "<cmd>Telescope diagnostics<CR>", vim.tbl_extend('force', opts, { desc = 'Telescope Diagnostic' }))
  map(buffer, "n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", vim.tbl_extend('force', opts, { desc = 'Signature info' }))
  map(buffer, "n", "[d", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", vim.tbl_extend('force', opts, { desc = 'Prev Buffer' }))
  map(buffer, "n", "]d", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<CR>", vim.tbl_extend('force', opts, { desc = 'Next Buffer' }))
  map(buffer, "n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", vim.tbl_extend('force', opts, { desc = 'Quick fix' }))
end

return M
