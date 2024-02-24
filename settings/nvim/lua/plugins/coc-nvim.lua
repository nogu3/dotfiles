return {
  'neoclide/coc.nvim', 
  branch = "release",
  event = "InsertEnter",
  config = function()
    vim.g.coc_global_extensions = {
       "coc-json",
       "coc-solargraph",
			 "coc-docker",
    }
  end
}
