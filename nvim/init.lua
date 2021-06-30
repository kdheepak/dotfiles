-- For debugging purpose
function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end

require 'kdheepak/plugins'

require 'kdheepak/settings'

require 'kdheepak/keymappings'

require 'kdheepak/autocommands'

require 'kdheepak/vim'

require 'kdheepak/color'
