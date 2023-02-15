local test_helpers = require("CottonCandy.test_helpers")
local lib_ts_nodes = require("CottonCandy.lib.ts_nodes")
local module = require("CottonCandy.lib.select_ts_nodes")

describe("select ts_node", function()
    before_each(function()
        test_helpers.set_lines([[
local my_func = function()
    local my_num = 100
    local my_str = "This is a string"
end
        ]])
        vim.bo.ft = "lua"
    end)

    it("works", function()
        local query = " ((identifier) @cap)"
        local nodes = lib_ts_nodes.get_nodes_from_query(query)

        module.select_node(nodes[3])

        vim.cmd("norm! ") -- go to Select Mode (from Visual Mode)
        vim.cmd("norm! omg") -- type in `omg`

        local want = [[
local my_func = function()
    local my_num = 100
    local omg = "This is a string"
end
        ]]
        local got = test_helpers.get_all_lines(true)
        assert.equals(want, got)
    end)
end)