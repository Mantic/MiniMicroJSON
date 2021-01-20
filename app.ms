import "json"

import "lib/jsonMod"
ModJSON = locals["lib/jsonMod"]

import "lib/jsonProfile"
ProfJSON = locals["lib/jsonProfile"]

import "lib/jsonCount"
CountJSON = locals["lib/jsonCount"]

import "lib/profiler"
Profiler = locals["lib/profiler"]


App = {}

App.run = function()
	clear
	print "Running json profiler..."
	print

	filePath = "res/dungeon1.json"
	self.test CountJSON, "JSON Func Count", filePath, 1


	// Run profile on smaller JSON file.
	time1 = self.test(json, "Standard JSON lib", filePath, 20)
	time2 = self.test(ModJSON, "Modded JSON lib", filePath, 20)

	speed = "faster"
	diff = round((1 - (time2/time1)), 4)
	if time2 > time1 then speed = "slower"
	print "Modded difference: " + diff + "% " + speed + ". (" + abs(time2-time1) + " seconds)"
	print


	// Run profile on larger JSON file.
	print "Loading large JSON file (250,000 array elements)..."
	wait 2

	filePath = "res/bigone.json"
	time1 = self.test(json, "Standard JSON lib", filePath, 5)
	time2 = self.test(ModJSON, "Modded JSON lib", filePath, 5)

	speed = "faster"
	diff = round((1 - (time2/time1)), 4)
	if time2 > time1 then speed = "slower"
	print "Modded difference: " + diff + "% " + speed + ". (" + abs(time2-time1) + " seconds)"
	print

end function

App.test = function(jsonLib, title, filePath, count = 1)
	print "[" + title + "] Running profiler..." 

	total = 0
	fnList = false

	for i in range(0, count - 1)
		if not file.exists(filePath) then
			print "File not found: " + filePath
			return
		end if

		fHandle = file.open(filePath)
		fSource = fHandle.read

		if fSource == "" then
			print "Cannot load file: " + filePath
			return
		end if

		p = new Profiler
		p.start
		tmap = jsonLib.parse(fSource)
		total = total + p.stop
		
		if jsonLib.hasIndex("fnList") then 
			fnList = jsonLib.fnList
		end if

	end for

	// if count > 1 then
		print "Avg run time of " + (total/count) + " over " + count + " iteration(s)."
	// end if

	if fnList then 
		print
		print "Function list: "

		vals = fnList.values
		for i in range(0, vals.len - 1)
			mod = "."
			if vals[i].count > 1 then mod = "s."

			print "   " + vals[i].name + " called: " + vals[i].count + " time"+mod
		end for

		print
	end if

	print
	return (total/count)
end function


App.run