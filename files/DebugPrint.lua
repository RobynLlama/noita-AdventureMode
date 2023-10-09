--Quick little hack to enable globally controlling print statements
--without needing to comment out each one
local DEBUG_PRINT = false

function dPrint(message)
    if (DEBUG_PRINT) then
        print(message)
    end
end