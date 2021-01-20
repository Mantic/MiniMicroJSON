Clock = {
	"startTime": 0, 
	"lapTime": 0,
	"laps": null,
}

Clock.start = function()
	self.startTime = time
	self.lapTime = time
	self.laps = []
end function

Clock.stop = function(msg)
	if self.startTime == 0 then
		return
	end if

	runTotal = time - self.startTime

	avg = runTotal
	total = 0
	extra = ""
	if self.laps.len > 0 then 
		for i in range(0, self.laps.len - 1)
			total = total + self.laps[i]
		end for

		avg = total / self.laps.len
		extra = " with " + self.laps.len + " laps. Avg: " + avg
	end if

	if msg isa string then
		print "Time [" + msg + "] : " + runTotal + extra
	end if

	self.startTime = 0
	self.lapTime = 0
	self.laps = null

	return runTotal
end function

Clock.lap = function()
	if self.laps == null then return

	diff = time - self.lapTime
	self.lapTime = time
	self.laps.push diff
	// print "Lap [" + msg + "] : " + diff + " Total Time: " + (self.lapTime - self.startTime)
end function


return Clock