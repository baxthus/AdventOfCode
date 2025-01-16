local function parse_input(filename)
    local replacements = {}
    local melecule = ''

    for line in io.lines(filename) do
        if line:find('=>') then
            local from, to = line:match('(.+) => (.+)')
            table.insert(replacements, { from = from, to = to })
        elseif line ~= '' then
            melecule = line
        end
    end

    return replacements, melecule
end

local function mutate(molecule, replacements)
    local distinct_molecules = {}
    for _, rep in ipairs(replacements) do
        local start = 1
        while true do
            local i, j = molecule:find(rep.from, start, true)
            if not i then break end
            local new_molecule = molecule:sub(1, i - 1) .. rep.to .. molecule:sub(j + 1)
            distinct_molecules[new_molecule] = true
            start = i + 1
        end
    end
    local result = {}
    for k in pairs(distinct_molecules) do
        table.insert(result, k)
    end
    return result
end

local function shuffle_replacements(replacements)
    math.randomseed(os.time())
    for i = #replacements, 2, -1 do
        local j = math.random(i)
        replacements[i], replacements[j] = replacements[j], replacements[i]
    end
end

local function search(molecule, replacements)
    local target = molecule
    local mutations = 0

    while target ~= 'e' do
        local tmp = target
        for _, rep in ipairs(replacements) do
            local i, j = target:find(rep.to, 1, true)
            if i then
                target = target:sub(1, i - 1) .. rep.from .. target:sub(j + 1)
                mutations = mutations + 1
            end
        end

        if tmp == target then
            target = molecule
            mutations = 0
            shuffle_replacements(replacements)
        end
    end

    return mutations
end

local replacements, molecule = parse_input('input.txt')

print('Part 1: ' .. #mutate(molecule, replacements))
print('Part 2: ' .. search(molecule, replacements))
