#!/usr/bin/luajit

g = {
	up   = "\027[1;37m↑\027[0m" ,
	line = "\027[1m│\027[0m"    ,
	down = "\027[1;37m↓\027[0m" ,
}

-- Utility function that reads a file or
-- stream line by line and outputs
-- it as a table
function readFrom(stream)
	local tmp = {}
	
	for line in stream:lines() do
		tmp[#tmp+1] = line
	end
	
	return tmp
end

-- Dividing the table in sections separated
-- By "EOS". then set the Title and the
-- Date of the section to their respective
-- Variables
function parse(table)
	local tmp = {}
	local group = 1
	local lnum = 1
	tmp[group] = {}
	
	for i,line in ipairs(table) do
		if line == "EOS" then
			group = group + 1
			tmp[group] = {}
			lnum = 1
		else
			if lnum == 1 then
				tmp[group].title = line
			elseif lnum == 2 then
				tmp[group].date = line
			else
				tmp[group][#tmp[group]+1] = line
			end
			lnum=lnum+1
		end
	end
	return tmp
end

function printParsed(table)
	print(g.up)
	print(g.line)
	for i,content in ipairs(table) do
		-- Title
		io.write("\027[1;36m") -- Bold, cyan
		io.write(g.line,"    ")
		io.write("\027[1;36m") -- Bold, cyan
		print(content.title)
		-- Date
		io.write("\027[1;31m") -- Bold, red
		io.write(g.line,"    ")
		io.write("\027[1;31m") -- Bold, red
		print(content.date)
		-- Text
		for j=1,#content do
			io.write("\027[0;37m") -- Normal, white
			io.write(g.line,"    ")
			io.write("\027[0;37m") -- Normal, white
			print(content[j])
		end
		print(g.line)
	end
	print(g.down)
end

printParsed(parse(readFrom(io.stdin)))
