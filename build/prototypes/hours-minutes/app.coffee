# Setup Variables
document.body.style.cursor = "auto"
Screen.backgroundColor = '#000'
Canvas.image = 'https://struanfraser.co.uk/images/youview-back.jpg'

youviewBlue = '#00a6ff'
youviewBlue2 = '#0F5391'
youviewBlue3 = '#032230'
youviewGrey1 = '#b6b9bf'
youviewGrey2 = '#83858a'
darkGrey3 = '#505359'
black = '#000'
white = '#ebebeb'
veryDarkGrey4 = '#171717'
veryDarkGrey5 = '#0D0D0D'



#Playback Bar Layers
playbackBarContainer = new Layer
	width:1280, height:720
	backgroundColor:'transparent'

topGradient = new Layer
	parent:playbackBarContainer
	width:1280
	height:109
	image:'images/top-gradient.png'
	index:0

gradient = new Layer
	parent:playbackBarContainer
	y: Align.bottom
	width:1280, height:390
	image:'images/playback-bar-bg.png'
	opacity:1
	index:0

playbackLine = new Layer
	parent:playbackBarContainer
	width:798, height:4
	x:274, y:617

bufferLine = new Layer
	parent:playbackLine
	height:4, width:797
	backgroundColor: '#0f5391'

playedLine = new Layer
	parent:bufferLine
	height:4, width:700
	backgroundColor:'#00a6ff'

playheadLine = new Layer
	parent:playedLine
	height:10, width:4
	y:-3, x:Align.right
	backgroundColor:'#00a6ff'

startTime = new TextLayer
	parent:playbackBarContainer
	text:''
	width:50, height:16
	fontSize:16, fontFamily:'sans-serif, fsme-bold', letterSpacing:0.3, color:'#b5b5b5'
	color:youviewBlue
	maxY:playbackLine.maxY+4, x:209

endTime = new TextLayer
	parent:playbackBarContainer
	autoWidth:true
	text:''
	width:50, height:16
	fontSize:16, fontFamily:'sans-serif, fsme-bold', letterSpacing:0.3, color:'#b5b5b5'
	maxY:playbackLine.maxY+4, x:playbackLine.maxX + 8

patchBack = new Layer
	parent:playbackBarContainer
	image:'images/patch-highlight.png'
	backgroundColor:'rgba(0,0,0,0.95)'
	height:129
	width:130
	y:510, x:64
	index:0

patchIconContainer = new Layer
	parent:playbackBarContainer
	midX:patchBack.midX
	y:patchBack.y + 24
	height:50, width:50
	clip:true
	backgroundColor: 'transparent'

patchIcon = new Layer
	parent:patchIconContainer
	image:'images/playback-sprites.png'
	height:750, width:50
	x:-1,y:-22
	backgroundColor: 'transparent'

patchRCNInput = new TextLayer
	parent:patchBack
	width:120, height:36, y:30
	fontFamily: 'sans-serif, fsme-bold', fontSize: 30, textAlign: 'center', letterSpacing: 1.12
	color:'#ebebeb'
	text:''

patchText = new TextLayer
	parent:playbackBarContainer
	text:'Play'
	midX:patchBack.midX
	y:startTime.y
	fontFamily:'sans-serif, fsme-bold', fontSize:16, color:'#ebebeb', textTransform:'uppercase', textAlign:'center'
	height:16, width:128
	clip:true
	backgroundColor: 'transparent'

title = new TextLayer
	parent:playbackBarContainer
	text: "Gulliver's Travels"
	fontFamily:'sans-serif, fsme-light', fontSize:36, color:'#ebebeb'
	width:848, height:36
	x:startTime.x, y:550

# Instructions
instBackground = new Layer
	width: 500
	height: 220
	backgroundColor: '#1f1f1f'
	borderStyle: 'dotted'
	borderRadius: 20
	borderWidth: 2
	borderColor: 'white'
	x: 20, y: 20
instTitle = new TextLayer
	parent: instBackground
	text: 'Instructions'
	x: 30, y: 15, color: white
instDesc = new TextLayer
	parent: instBackground
	html: '
	<p style="margin-bottom:5px;">0-9 – number input</p>
	<p style="margin-bottom:5px;">⏎ – OK / Play</p>', fontSize: 20
	x: 30, y: 75, color: white

# Clock
today = new Date
hour = today.getHours()
minute = today.getMinutes()

Utils.interval 60, ->
	refreshTime()

currentTime = new TextLayer
	parent:topGradient
	text:hour + ':' + minute
	maxX:1216
	y:36
	fontFamily:'sans-serif, fsme'
	fontSize:30
	color:'#ebebeb'

if minute < 10
	currentTime.text = hour+':0'+minute
else
	currentTime.text = hour+':'+minute

refreshTime = () ->
	today = new Date
	hour = today.getHours()
	minute = today.getMinutes()
	if minute < 10
		currentTime.text = hour+':0'+minute
	else
		currentTime.text = hour+':'+minute
		currentTime.maxX = 1216
refreshTime()

#Video Content and Management

background = new BackgroundLayer
	backgroundColor: '#000'

recording = new VideoLayer
	parent:background
	video:'https://ia800207.us.archive.org/10/items/GulliversTravels720p/GulliversTravels1939_512kb.mp4'
	width:1280, height:800
	backgroundColor: '#000'
recording.center()
recording.player.autoplay = true
# recording.player.controls = true
recording.ignoreEvents = false
playTime = recording

recording.player.addEventListener "timeupdate", ->
	# Calculate progress bar position
	newPos = (playbackLine.width / recording.player.duration) * recording.player.currentTime
	playheadLine.x = newPos
	playedLine.width = newPos
	if getHoursOf(recording.player.duration) > 0 and getHoursOf(recording.player.currentTime) < 1
		startTime.text = '0:' + timeParser(recording.player.currentTime)
	else
		startTime.text = timeParser(recording.player.currentTime)
	endTime.text = timeParser(recording.player.duration)

skipTo = (time) ->
	recording.player.currentTime = time

timeParser = (time) ->
	rationalTime = Math.round(time)
	if rationalTime < 60 and rationalTime < 10
		return '00:0' + rationalTime
	else if rationalTime < 60 and rationalTime > 9
		return '00:' + rationalTime
	else if rationalTime >= 60
		if rationalTime >= 570
			if getMinutesOf(rationalTime) < 10
				minutes = '0' + getMinutesOf(rationalTime)
			else minutes = getMinutesOf(rationalTime)
		else
			minutes = '0' + getMinutesOf(rationalTime)
		seconds = getSecondsOf(rationalTime)
		if seconds < 10
			singleDigit = seconds
			seconds = '0' + singleDigit
		if rationalTime >= 3600
			hours = getHoursOf(rationalTime)
			return hours + ':' + minutes + ':' + seconds
		return minutes + ':' + seconds

getHoursOf = (rationalTime) ->
	minutes = rationalTime / 60
	hours = Math.floor( minutes / 60 )
	return hours
getMinutesOf = (rationalTime) ->
	totalMinutes = rationalTime / 60
	minutes = Math.floor( totalMinutes % 60 )
	return minutes
getSecondsOf = (rationalTime) ->
	seconds = Math.floor( rationalTime % 60 )
	return seconds


# Keys
del = 8
guide = 9
ok = 13
record = 17

sub = 18
ad = 20
close = 27
pUp = 33
pDown = 34
mainMenu = 36

left = 37
up = 38
right = 39
down = 40
back = 46

zero = 48
one = 49
two = 50
three = 51
four = 52
five = 53
six = 54
seven = 55
eight = 56
nine = 57

info = 73
record = 82
stop = 111
help = 112
myTV = 115

red = 116
green = 117
yellow = 118
blue = 119

pause = 186
rewind = 188
fastForward = 190
stop = 191
mute = 220
play = 222

text = 120
power = 124
search = 192

skipBackward = 219
skipForward = 221

# Key Listener
stopKeyInput = () ->
	document.removeEventListener 'keydown', (event) ->
startKeyInput = () ->
	document.addEventListener 'keydown', (event) ->
		keyCode = event.which
		eventHandler(keyCode)
		event.preventDefault()
startKeyInput()

barTimeOut = 0
timeOut = 0

eventHandler = Utils.throttle 0.1, (keyCode) ->
	barTimeOut = 0
	playbackBarContainer.animate
		opacity:1
		y:0
		options:
			curve:'ease-in-out'
			time:0.5
	switch keyCode
		when one
			timeJump(1)
		when two
			timeJump(2)
		when three 
			timeJump(3)
		when four
			timeJump(4)
		when five
			timeJump(5)
		when six
			timeJump(6)
		when seven
			timeJump(7)
		when eight
			timeJump(8)
		when nine
			timeJump(9)
		when zero
			timeJump(0)
		when ok
			jumpToTime( patchRCNInput.text )
			timeOut = 5
		when red
			changeVideo()

changeVideo = () ->
	if recording.video == 'video/taboo.mp4'
		title.text = 'Guardians of the Galaxy'
		recording.video = 'video/Guardians of the Galaxy_downscale.mp4'
		recording.player.currentTime = 0
		recording.player.play()
	else if recording.video == 'video/Guardians of the Galaxy_downscale.mp4'
		recording.video = 'video/taboo.mp4'
		title.text = 'Taboo'
		recording.player.currentTime = 0
		recording.player.play()

clearTimeInput = () ->
	patchRCNInput.text = ''
	patchRCNInput.color = white
	patchIcon.visible = true
	patchText.text = 'Play'

Utils.interval 0.5, ->
	if barTimeOut == 13
		playbackBarContainer.animate
			opacity:0
			y:playbackBarContainer.y+20
			options:
				curve:'ease-in-out'
				time:0.5
	barTimeOut++
	if timeOut == 5
		if getHoursOf(recording.player.duration) >= 1 then maxInput = 7 else maxInput = 5
		if maxInput == 7
			switch patchRCNInput.text.length
				when 2
					patchRCNInput.text+='00:00'
				when 3
					patchRCNInput.text+='0:00'
				when 5
					patchRCNInput.text+='00'
				when 6
					patchRCNInput.text+='0'
		if maxInput == 5
			switch patchRCNInput.text.length
				when 1
					minute = patchRCNInput.text
					patchRCNInput.text = '0' + minute + ':00'
				when 3
					patchRCNInput.text += '00'
				when 4
					patchRCNInput.text+='0'
		jumpToTime( patchRCNInput.text )
	timeOut++

timeJump = ( input ) ->
	timeOut = 0
	patchIcon.visible = false
	patchText.text = 'Jump To'
	if getHoursOf(recording.player.duration) >= 1 then maxInput = 7 else maxInput = 5
	if maxInput == 7 and patchRCNInput.text.length != maxInput+1
		# If it's longer than an hour
		if getHoursOf(recording.player.duration) >= 1 
			# If it's the first key input
			if patchRCNInput.text.length < 1
				# If the input is less than the hour length of the recording.
				if input <= getHoursOf(recording.player.duration)
					patchRCNInput.text = input + ':'
				else 
					patchRCNInput.text = '0:' + input
			# If it's after first input
			else if patchRCNInput.text.length >= 1
				if patchRCNInput.text.length == 0 or patchRCNInput.text.length == 3
					patchRCNInput.text += input + ':'
				else
					patchRCNInput.text += input
	else if maxInput == 5 and patchRCNInput.text.length != maxInput+1
		if patchRCNInput.text.length == 1
			patchRCNInput.text += input + ':'
		
		else if patchRCNInput.text.length == 2
			patchRCNInput.text += input
		else if patchRCNInput.text.length < maxInput
			patchRCNInput.text += input
		
	if patchRCNInput.text.length == maxInput then jumpToTime( patchRCNInput.text )

jumpToTime = ( timeString, maxInput ) ->
	stopKeyInput()
	newTimes = timeString.split(':')
	if newTimes.length == 2
		irrationalTime = (60 * parseInt(newTimes[0])) + parseInt(newTimes[1])
	else if newTimes.length == 3
		irrationalTime = (Math.pow(60, 2) * parseInt(newTimes[0]) + (parseInt(newTimes[1]) * 60) + parseInt(newTimes[2]))
	else if newTimes.length == 1
		irrationalTime = (parseInt(newTimes[0]) * 60) + parseInt(newTimes[1])
	if irrationalTime < recording.player.duration
		skipTo(irrationalTime)
		patchRCNInput.color = youviewBlue

	Utils.delay 1, ->
		clearTimeInput()
		startKeyInput()
		patchRCNInput.visible = true