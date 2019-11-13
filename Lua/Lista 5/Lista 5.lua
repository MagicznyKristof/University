table.reverse = function(table)
    local res = {}
    for i = #table, 1, -1 do
        res[#res + 1] = table[i]
    end
    return res
end

table.map = function(f, table)
    local res = {}
    for i = 1, #table do
        res[i] = f(table[i])
    end
    return res
end

-- Zadanie 1 ------------------------------------------------------------------
---[[
print '--- Zadanie 1 ---'

function chain(...)
    return function (state)
        while state[#state] and #(state[#state]) == 0 do
            state[#state] = nil
        end
        if #state > 0 then
            local res = state[#state][#(state[#state])]
            state[#state][#(state[#state])] = nil
            return res
        end
    end, table.map(table.reverse, table.reverse{...})
end

for x in chain({'a', 'b', 'c'}, {40, 50}, {}, {6, 7}) do
    print(x)
end
--[[
print('---')

for x in chain({1,2,3,5,6,7}, {2,5,5,4,7}) do
    print(x)
end
--]]
-- Zadanie 2 ------------------------------------------------------------------
---[[
print '--- Zadanie 2 ---'

function zip(...)
    return function (state)
        local res = {}
        for i = 1, #state do
            if #(state[i]) == 0 then return end
            res[#res + 1] = state[i][#(state[i])]
            state[i][#(state[i])] = nil
        end
        return table.unpack(res)
    end, table.map(table.reverse, {...})
end

for x, y in zip({'a', 'b', 'c', 'd'}, {40, 50, 60}) do
    print(x, y)
end

--[[
print('-----')

for x, y, z in zip({'a', 'b', 'c', 'd'}, {40, 50, 60}, {1, 2, 3, 4, 5, 6}) do
    print(x, y, z)
end

print('-----')

for x, y in zip({}, {}) do
    print(x, y)
end

--]]