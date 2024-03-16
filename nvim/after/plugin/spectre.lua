local spectre = require("spectre")
local state = require("spectre.state")

local last_search_path = nil

local remembered_open = spectre.open
function patched_open(opts)
    if opts == nil then
        opts = {path = last_search_path}
    end
    opts.path = last_search_path
    remembered_open(opts)
end
spectre.open = patched_open

local remembered_on_leave = spectre.on_leave
function patched_on_leave()
    remembered_on_leave()
    last_search_path = state.query.path
end
spectre.on_leave = patched_on_leave
