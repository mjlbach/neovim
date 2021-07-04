-- shada buffer list saving/reading support
local helpers = require "test.functional.helpers"(after_each)
local nvim_command, funcs, eq, curbufmeths = helpers.command, helpers.funcs, helpers.eq, helpers.curbufmeths

local shada_helpers = require "test.functional.shada.helpers"
local reset, clear = shada_helpers.reset, shada_helpers.clear

describe("shada support code", function()
  local testfilename = "Xtestfile-functional-shada-buffers"
  local testfilename_2 = "Xtestfile-functional-shada-buffers-2"
  after_each(clear)

  it("is able to dump and restore buffer list", function()
    reset "set shada+=%"
    nvim_command("edit " .. testfilename)
    nvim_command("edit " .. testfilename_2)
    nvim_command "qall"
    reset "set shada+=%"
    eq(3, funcs.bufnr "$")
    eq("", funcs.bufname(1))
    eq(testfilename, funcs.bufname(2))
    eq(testfilename_2, funcs.bufname(3))
  end)

  it("does not restore buffer list without % in &shada", function()
    reset "set shada+=%"
    nvim_command("edit " .. testfilename)
    nvim_command("edit " .. testfilename_2)
    nvim_command "qall"
    reset()
    eq(1, funcs.bufnr "$")
    eq("", funcs.bufname(1))
  end)

  it("does not dump buffer list without % in &shada", function()
    reset()
    nvim_command("edit " .. testfilename)
    nvim_command("edit " .. testfilename_2)
    nvim_command "qall"
    reset "set shada+=%"
    eq(1, funcs.bufnr "$")
    eq("", funcs.bufname(1))
  end)

  it("does not dump unlisted buffer", function()
    reset "set shada+=%"
    nvim_command("edit " .. testfilename)
    nvim_command("edit " .. testfilename_2)
    curbufmeths.set_option("buflisted", false)
    nvim_command "qall"
    reset "set shada+=%"
    eq(2, funcs.bufnr "$")
    eq("", funcs.bufname(1))
    eq(testfilename, funcs.bufname(2))
  end)

  it("does not dump quickfix buffer", function()
    reset "set shada+=%"
    nvim_command("edit " .. testfilename)
    nvim_command("edit " .. testfilename_2)
    curbufmeths.set_option("buftype", "quickfix")
    nvim_command "qall"
    reset "set shada+=%"
    eq(2, funcs.bufnr "$")
    eq("", funcs.bufname(1))
    eq(testfilename, funcs.bufname(2))
  end)

  it("does not dump unnamed buffers", function()
    reset "set shada+=% hidden"
    curbufmeths.set_lines(0, 1, true, { "foo" })
    nvim_command "enew"
    curbufmeths.set_lines(0, 1, true, { "bar" })
    eq(2, funcs.bufnr "$")
    nvim_command "qall!"
    reset "set shada+=% hidden"
    eq(1, funcs.bufnr "$")
    eq("", funcs.bufname(1))
  end)

  it("restores 1 buffer with %1 in &shada, #5759", function()
    reset "set shada+=%1"
    nvim_command("edit " .. testfilename)
    nvim_command("edit " .. testfilename_2)
    nvim_command "qall"
    reset "set shada+=%1"
    eq(2, funcs.bufnr "$")
    eq("", funcs.bufname(1))
    eq(testfilename, funcs.bufname(2))
  end)
end)
