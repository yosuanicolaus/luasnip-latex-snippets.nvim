local ls = require("luasnip")
local utils = require("luasnip-latex-snippets.util.utils")
local pipe = utils.pipe

local M = {}

function M.retrieve(not_math)
  local ps = ls.parser.parse_snippet
  local ps_nm = ls.extend_decorator.apply(ls.parser.parse_snippet, {
    condition = pipe({ not_math }),
  }) --[[@as function]]

  return {
    ps_nm({ trig = "mk", name = "Math" }, "\\( ${1:${TM_SELECTED_TEXT}} \\)$0"),
    ps_nm({ trig = "dm", name = "Block Math" }, "\\[\n\t${1:${TM_SELECTED_TEXT}}\n\\]$0"),

    ps({ trig = "txb", name = "Bold text" }, "\\textbf{$1}$0"),
    ps({ trig = "txi", name = "Italic text" }, "\\textit{$1}$0"),
  }
end

return M
