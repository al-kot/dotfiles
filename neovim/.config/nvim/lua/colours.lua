local pals_everforest = require("everforest.colours")
local config = require("everforest").config

return {
    everforest = pals_everforest.generate_palette(config, vim.o.background),
}
