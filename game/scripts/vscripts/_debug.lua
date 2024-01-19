function table.make_key_table(t)
    local r = {}
    for k, _ in pairs(t) do
        table.insert(r, k)
    end
    return r
end


function table.make_value_table(t)
    local r = {}
    for _, v in pairs(t) do
        table.insert(r, v)
    end
    return r
end


function table.rank(t, order)
	if not t then return {} end

	local ranks = {}

	-- extract all unique values into a table
	local unique_values = {}
	for k, v in pairs(t) do
		unique_values[v] = true
	end

	-- then sort it in specified order
	local values_array = table.make_key_table(unique_values)

	local comparator
	if order ~= nil and type(order) ~= "boolean" then error("Invalid order parameter - only nil / false / true are supported") end
	-- for nil / false we don't have to define comparator - usage of `<` is default behaviour of `sort`
	if order then comparator = function(a, b) return a > b end end

	table.sort(values_array, comparator)

	-- now convert array to associative table, where for every value it's index is it's rank
	local values_ranks = {}
	for rank, value in ipairs(values_array) do
		values_ranks[value] = rank
	end

	-- and assign that to initial table
	for k, v in pairs(t) do
		ranks[k] = values_ranks[v]
	end

	return ranks
end


function table.rank_2(t, order)
	if not t then return {} end

	local ranks = {}

	local values = table.make_value_table(t)

	local comparator
	if order ~= nil and type(order) ~= "boolean" then error("Invalid order parameter - only nil / false / true are supported") end
	-- for nil / false we don't have to define comparator - usage of `<` is default behaviour of `sort`
	if order then comparator = function(a, b) return a > b end end

	table.sort(values, comparator)

	local seen_values = {}
	local current_rank = 1

	for _, value in ipairs(values) do
		if not seen_values[value] then seen_values[value] = current_rank end
		current_rank = current_rank + 1
	end

	for k, v in pairs(t) do
		if seen_values[v] then
			ranks[k] = seen_values[v]
		end
	end

	return ranks
end


local test = {
	[1] = 0, -- 1
	[2] = 0, -- 1
	[3] = 0, -- 1
	[4] = 0, -- 6
	[5] = 0, -- 1
	[6] = 0, -- 9
	[7] = 0, -- 11
	[8] = 0, -- 1
	[9] = 0, -- 6
	[10] = 0, -- 6
	[11] = 0, -- 11
	[12] = 1, -- 14
	[13] = 1, -- 9
	[14] = 1, -- 15
	[15] = 3, -- 13
}


local result = table.rank_2(test, false)


for i, x in pairs(result) do
	print(i, x)
end
