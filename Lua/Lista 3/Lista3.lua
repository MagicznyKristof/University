

-- Zadanie 1 ------------------------------------------------------------------
---[=[
utf8.reverse = function( word )
    local letters = {utf8.codepoint(word, 1, -1)}
    local res = {}
    for i = 1, #letters do
        res[i] = letters[#letters + 1 - i]
    end
    return utf8.char(table.unpack(res))
end

print(utf8.reverse('Księżyc'))
print(utf8.reverse('♠♣♥♦'))
--]=]
-- Zadanie 2 ------------------------------------------------------------------
---[=[
utf8.normalize = function( word )
    local res = {}
    for i, c in utf8.codes(word) do
        if 0 <= c and c <= 127 then
            res[#res + 1] = c
        end
    end
    return utf8.char(table.unpack(res))
end

print(utf8.normalize('Księżyc:\nNów'))
print(utf8.normalize('Gżegżółka'))
--]=]
-- Zadanie 3 ------------------------------------------------------------------
---[=[
utf8.sub = function(word, be, en)
    local begin_ind = be or 1
    local end_ind = en or -1
    local word_len = utf8.len(word)
    if begin_ind < 0 then begin_ind = word_len + begin_ind + 1 end
    if end_ind < 0 then end_ind = word_len + end_ind + 1 end
    local result = {}
    for i, c in ipairs({utf8.codepoint(word, 1, -1)}) do
        if begin_ind <= i and i <= end_ind then 
            result[#result + 1] = c
        end
    end
    return utf8.char(table.unpack(result))
end

print(utf8.sub('Księżyc:\nNów', 4, 10))
--]=]
-- Zadanie 4 ------------------------------------------------------------------
---[=[
string.strip = function(word, chars)
    local removal_chars = chars or ' \t\n'
    local removal_map = {}
    for _, c in ipairs({removal_chars:byte(1, -1)}) do
        removal_map[c] = 1
    end
    local letters = {word:byte(1, -1)}
    while removal_map[letters[#letters]] ~= nil do
        letters[#letters] = nil
    end
    return string.char(table.unpack(letters))
end

print(string.strip('test string \t \n     '))
print(string.strip ('test string', 'tng'))
--]=]
-- Zadanie 5 ------------------------------------------------------------------
--[=[
string.split = function(word, sep)
    local separator = sep or ' '
    separator = separator:byte()
    local res = {}
    local beginning = 1
    local ending = 1
    local word_chars = {word:byte(1, -1)}
    while ending <= #word_chars do
        if separator == word_chars[ending] then 
            res[#res + 1] = word:sub(beginning, ending - 1)
            beginning, ending = ending + 1, ending + 1
        else
            ending = ending + 1
        end
    end
    res[#res + 1] = word:sub(beginning, ending - 1)
    return res
end

printf(string.split(' test string  '))
printf(string.split('test,12,5,,xyz', ','))
--]=]