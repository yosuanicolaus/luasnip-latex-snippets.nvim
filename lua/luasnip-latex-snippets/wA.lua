local ls = require("luasnip")
local conds = require("luasnip.extras.expand_conditions")
local utils = require("luasnip-latex-snippets.util.utils")
local pipe = utils.pipe

local M = {}

function M.retrieve(not_math)
  local ps_lb_nm = ls.extend_decorator.apply(
    ls.parser.parse_snippet,
    { condition = pipe({ conds.line_begin, not_math }) }
  ) --[[@as function]]
  local parse_snippet = ls.extend_decorator.apply(ls.parser.parse_snippet, {
    condition = pipe({ not_math }),
  }) --[[@as function]]

  return {
    parse_snippet({ trig = "mk", name = "Math" }, "\\( ${1:${TM_SELECTED_TEXT}} \\)$0"),
    parse_snippet({ trig = "dm", name = "Block Math" }, "\\[\n\t${1:${TM_SELECTED_TEXT}}\n\\]$0"),

    ps_lb_nm(
      { trig = "templ", name = "default template" },
      "\\documentclass[a4paper,12pt]{article}\n\\input{"
        .. vim.fn.getcwd()
        .. "/template/default.tex"
        .. "}\n\\title{${1:Lecture Notes}}\n"
        .. "\\date{"
        .. os.date("%Y-%m-%d")
        .. "}\n"
        .. "\\begin{document}\n\\maketitle\n\n${2:Hello, world!}\n\n\\end{document}"
    ),
    ps_lb_nm({ trig = "hr", name = "line break" }, "\\noindent\\rule{\\textwidth}{1pt}\n$1"),
  }
end

return M
