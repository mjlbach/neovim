-- Tests for :[count]close! and :[count]hide

local helpers = require "test.functional.helpers"(after_each)

local eq = helpers.eq
local poke_eventloop = helpers.poke_eventloop
local eval = helpers.eval
local feed = helpers.feed
local clear = helpers.clear
local command = helpers.command

describe("close_count", function()
  setup(clear)

  it("is working", function()
    command "let tests = []"
    command "for i in range(5)|new|endfor"
    command "4wincmd w"
    command "close!"
    command "let buffers = []"
    command 'windo call add(buffers, bufnr("%"))'
    eq({ 6, 5, 4, 2, 1 }, eval "buffers")
    command "1close!"
    command "let buffers = []"
    command 'windo call add(buffers, bufnr("%"))'
    eq({ 5, 4, 2, 1 }, eval "buffers")
    command "$close!"
    command "let buffers = []"
    command 'windo call add(buffers, bufnr("%"))'
    eq({ 5, 4, 2 }, eval "buffers")
    command "1wincmd w"
    command "2close!"
    command "let buffers = []"
    command 'windo call add(buffers, bufnr("%"))'
    eq({ 5, 2 }, eval "buffers")
    command "1wincmd w"
    command "new"
    command "new"
    command "2wincmd w"
    command "-1close!"
    command "let buffers = []"
    command 'windo call add(buffers, bufnr("%"))'
    eq({ 7, 5, 2 }, eval "buffers")
    command "2wincmd w"
    command "+1close!"
    command "let buffers = []"
    command 'windo call add(buffers, bufnr("%"))'
    eq({ 7, 5 }, eval "buffers")
    command "only!"
    command "b1"
    command "let tests = []"
    command "for i in range(5)|new|endfor"
    command "let buffers = []"
    command 'windo call add(buffers, bufnr("%"))'
    eq({ 13, 12, 11, 10, 9, 1 }, eval "buffers")
    command "4wincmd w"
    command ".hide"
    command "let buffers = []"
    command 'windo call add(buffers, bufnr("%"))'
    eq({ 13, 12, 11, 9, 1 }, eval "buffers")
    command "1hide"
    command "let buffers = []"
    command 'windo call add(buffers, bufnr("%"))'
    eq({ 12, 11, 9, 1 }, eval "buffers")
    command "$hide"
    command "let buffers = []"
    command 'windo call add(buffers, bufnr("%"))'
    eq({ 12, 11, 9 }, eval "buffers")
    command "1wincmd w"
    command "2hide"
    command "let buffers = []"
    command 'windo call add(buffers, bufnr("%"))'
    eq({ 12, 9 }, eval "buffers")
    command "1wincmd w"
    command "new"
    command "new"
    command "3wincmd w"
    command "-hide"
    command "let buffers = []"
    command 'windo call add(buffers, bufnr("%"))'
    eq({ 15, 12, 9 }, eval "buffers")
    command "2wincmd w"
    command "+hide"
    command "let buffers = []"
    command 'windo call add(buffers, bufnr("%"))'
    eq({ 15, 12 }, eval "buffers")
    command "only!"
    command "b1"
    command "let tests = []"
    command "set hidden"
    command "for i in range(5)|new|endfor"
    command "1wincmd w"
    command "$ hide"
    command "let buffers = []"
    command 'windo call add(buffers, bufnr("%"))'
    eq({ 20, 19, 18, 17, 16 }, eval "buffers")
    command "$-1 close!"
    command "let buffers = []"
    command 'windo call add(buffers, bufnr("%"))'
    eq({ 20, 19, 18, 16 }, eval "buffers")
    command "1wincmd w"
    command ".+close!"
    command "let buffers = []"
    command 'windo call add(buffers, bufnr("%"))'
    eq({ 20, 18, 16 }, eval "buffers")
    command "only!"
    command "b1"
    command "let tests = []"
    command "set hidden"
    command "for i in range(5)|new|endfor"
    command "4wincmd w"
    feed "<C-W>c<cr>"
    poke_eventloop()
    command "let buffers = []"
    command 'windo call add(buffers, bufnr("%"))'
    eq({ 25, 24, 23, 21, 1 }, eval "buffers")
    feed "1<C-W>c<cr>"
    poke_eventloop()
    command "let buffers = []"
    command 'windo call add(buffers, bufnr("%"))'
    eq({ 24, 23, 21, 1 }, eval "buffers")
    feed "9<C-W>c<cr>"
    poke_eventloop()
    command "let buffers = []"
    command 'windo call add(buffers, bufnr("%"))'
    eq({ 24, 23, 21 }, eval "buffers")
    command "1wincmd w"
    feed "2<C-W>c<cr>"
    poke_eventloop()
    command "let buffers = []"
    command 'windo call add(buffers, bufnr("%"))'
    eq({ 24, 21 }, eval "buffers")
  end)
end)
