local ls = require("luasnip")
local t = ls.text_node
local i = ls.insert_node

local M = {}

local function template_string(file_path)
  local title_str = "\\title{${1:Reading Notes}}\n"
  local maketitle_str = "\\maketitle\n"

  if file_path == "/template/tma_natural.tex" then
    title_str = "\\chead{${1:Reading Notes}}\n"
    maketitle_str = ""
  end

  return "\\documentclass[a4paper,12pt]{article}\n"
    .. "\\input{"
    .. vim.fn.getcwd()
    .. file_path
    .. "}\n"
    .. title_str
    .. "\\date{"
    .. os.date("%Y-%m-%d")
    .. "}\n"
    .. "\\begin{document}\n"
    .. maketitle_str
    .. "\n${2:Hello, world!}\n\n\\end{document}"
end

function M.retrieve(not_math)
  local utils = require("luasnip-latex-snippets.util.utils")
  local pipe = utils.pipe

  local conds = require("luasnip.extras.expand_conditions")
  local condition = pipe({ conds.line_begin, not_math })

  local parse_snippet = ls.extend_decorator.apply(ls.parser.parse_snippet, {
    condition = condition,
  }) --[[@as function]]

  local s = ls.extend_decorator.apply(ls.snippet, {
    condition = condition,
  }) --[[@as function]]

  return {
    s(
      { trig = "ali", name = "Align" },
      { t({ "\\begin{align*}", "\t" }), i(1), t({ "", "\\end{align*}" }) }
    ),

    parse_snippet({ trig = "beg", name = "begin{} / end{}" }, "\\begin{$1}\n\t$0\n\\end{$1}"),

    -- no special condition
    ls.parser.parse_snippet(
      { trig = "cases" },
      "\\begin{cases}\n\t${1:case_1} & ${2:cond_1} \\\\\\ \n\t${3:case_2} & ${4:cond_2} \\\\\\ \n\\end{cases}"
    ),

    parse_snippet({ trig = "hr", name = "line break" }, "\\noindent\\rule{\\textwidth}{1pt}\n$1"),

    parse_snippet(
      { trig = "tempd", name = "template default.tex" },
      template_string("/template/default.tex")
    ),
    parse_snippet(
      { trig = "temptma", name = "template real TMA" },
      template_string("/template/tma_real.tex")
    ),
    parse_snippet(
      { trig = "templ", name = "template natural" },
      template_string("/template/tma_natural.tex")
    ),

    s({ trig = "bigfun", name = "Big function" }, {
      t({ "\\begin{align*}", "\t" }),
      i(1),
      t(":"),
      t(" "),
      i(2),
      t("&\\longrightarrow "),
      i(3),
      t({ " \\", "\t" }),
      i(4),
      t("&\\longmapsto "),
      i(1),
      t("("),
      i(4),
      t(")"),
      t(" = "),
      i(0),
      t({ "", "\\end{align*}" }),
    }),
  }
end

return M
