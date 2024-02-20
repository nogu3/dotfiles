return {
  "dense-analysis/ale",
  ale_disable_lsp  =  1 ,
  ale_lint_on_text_changed = 1,
  ale_fix_on_save = 1,
  ale_fixers = {
    ['*'] = { "remove_trailing_lines", "trim_whitespace" },
    ['ruby'] = {'rubocop'}
  }
}
