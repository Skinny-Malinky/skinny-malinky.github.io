# Setup Variables
document.body.style.cursor = "auto"
Screen.backgroundColor = '#000'
Canvas.image = 'http://design-prototypes.dev.youview.co.uk/images/back.jpg'

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
getNumberSVG = (number) ->
	return numberSVG = '''<?xml version="1.0" encoding="UTF-8"?>
<svg version="1.1" viewBox="0 0 21 20" xmlns="http://www.w3.org/2000/svg">
<g fill="none" fill-rule="evenodd">
<g transform="translate(-805 -645)">
<g transform="translate(271 645)">
<g transform="translate(534.33)">
<path d="m20 10c0 5.523-4.477 10-10 10s-10-4.477-10-10 4.477-10 10-10 10 4.477 10 10" fill="#595959" fill-rule="evenodd"/>
<path d="m18 10c0 4.418-3.582 8-8 8s-8-3.582-8-8 3.582-8 8-8 8 3.582 8 8" fill="#000" fill-rule="evenodd"/>
<text fill="#EBEBEB" font-family="sans-serif, fsme-Bold, FS Me" font-size="14" font-weight="bold" letter-spacing=".28">
<tspan x="6" y="15">''' + number + '''</tspan></text>
</g></g></g></g></svg>
'''


Framer.Device.deviceType = "sony-w85Oc"

#Playback Bar Layers
playbackBarContainer = new Layer
	width:1280, height:720
	backgroundColor:'transparent'

topGradient = new Layer
# 	parent:playbackBarContainer
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
	backgroundColor: youviewBlue2

playedLine = new Layer
	parent:bufferLine
	height:4, width:0
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

svgPatchIcon = new Layer
	parent:patchIconContainer
	height:50, width:50
	backgroundColor:''
	visible:false

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
	text:"Gulliver's Travels"
	fontFamily:'sans-serif, fsme-light', fontSize:36, color:'#ebebeb'
	width:848, height:36
	x:startTime.x, y:550

remoteNumber = []
remoteNumber.timeOut = 0
for i in [0..9]
	remoteNumbers = new Layer
		backgroundColor:''
		html:getNumberSVG(i)
		parent:playbackLine
		x:80*i-9
		height:21, width:20
# 		backgroundColor:'red'
		opacity:0
		originY:0.2
	
	remoteNumber.push(remoteNumbers)

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
	width:1280, height:720
	backgroundColor: '#000'
	x:0, y:0
# recording.player.autoplay = true
recording.player.muted = true
# recording.player.controls = true
recording.ignoreEvents = false
playTime = recording

movePlayhead = () ->
	# Calculate progress bar position
	newPos = (playbackLine.width / recording.player.duration) * recording.player.currentTime
	playheadLine.x = newPos
	playedLine.width = newPos
	if getHoursOf(recording.player.duration) > 0 and getHoursOf(recording.player.currentTime) < 1
		startTime.text = '0:' + timeParser(recording.player.currentTime)
	else
		startTime.text = timeParser(recording.player.currentTime)
	endTime.text = timeParser(recording.player.duration)

recording.player.addEventListener "timeupdate", movePlayhead

skipTo = (time, input) ->
	newPos = playbackLine.width / 10 * input
	playheadLine.animate
		x: newPos
	playedLine.animate
		width: newPos
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
	showPlaybackBar()
	switch keyCode
		when one
			timeJump(recording.player.duration / 100 * 10, 1)
		when two
			timeJump(recording.player.duration / 100 * 20, 2)
		when three 
			timeJump(recording.player.duration / 100 * 30, 3)
		when four
			timeJump(recording.player.duration / 100 * 40, 4)
		when five
			timeJump(recording.player.duration / 100 * 50, 5)
		when six
			timeJump(recording.player.duration / 100 * 60, 6)
		when seven
			timeJump(recording.player.duration / 100 * 70, 7)
		when eight
			timeJump(recording.player.duration / 100 * 80, 8)
		when nine
			timeJump(recording.player.duration / 100 * 90, 9)
		when zero
			timeJump(0, 0)
		when ok
			playSpeed(1)
			timeOut = 5
		when fastForward
			playSpeed(16)
		when rewind
			playSpeed(-1)
		when play
			playSpeed(1)
		when red
			changeVideo()
		when left
			findNearest('left')
		when right
			findNearest('right')

findNearest = (direction) ->
	#Give or take 5000
	now = recording.player.currentTime
	duration = recording.player.duration
	currentPercent = now / duration * 100
	nearestTenth = Math.round(currentPercent / 10)
	if (direction == 'right' and nearestTenth <= 8)
		nearestTenth += 1
		print nearestTenth
		timeJump( duration / 100 * nearestTenth * 10, nearestTenth )
	else if (now < ( duration / nearestTenth + 5000 ) and nearestTenth > 0)
		nearestTenth = nearestTenth - 1
		timeJump(duration / 100 * nearestTenth*10, nearestTenth)

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
	patchIcon.visible = false
	patchRCNInput.text = ''
	patchRCNInput.color = white
	patchIcon.visible = true
	patchText.text = 'Play'
	svgPatchIcon.visible = false

Utils.interval 0.5, ->
	if barTimeOut == 13
		hidePlaybackBar()
	barTimeOut++
	timeOut++

timeJump = ( input, label ) ->
	recording.player.removeEventListener "timeupdate", movePlayhead
	timeOut = 0
	if remoteNumber[0].opacity > 0
		jumpToTime(input, label)

jumpToTime = ( irrationalTime, label ) ->
	if irrationalTime < recording.player.duration
		skipTo( irrationalTime, label )
		patchIcon.visible = false
		svgPatchInserter( label )
		for number, i in remoteNumber
			if i == label
				selectedNumber = number
				numberScale = selectedNumber.animate
# 					opacity: 1 # I have no idea why this doesn't work and it's driving me insane.
					scale: 1.4
					options:
						time:0.4
						curve:Spring(damping: 0.3)
				Utils.delay 1, ->
					numberScale.reverse().start()
			else
				number.scale = 1
				number.opacity = 0.6
	Utils.delay 2, ->
		clearTimeInput()
		startKeyInput()
		recording.player.addEventListener "timeupdate", movePlayhead
	playSpeed(1)

svgPatchInserter = ( input ) ->
	patchText.text = 'Jump To'
	svgPatchIcon.html = getNumberSVG( input )
	svgPatchIcon.visible = true
	
playSpeed = (speed) ->
	recording.player.playbackRate = speed
	if speed > 1
		patchText.text = 'x' + speed
		showNumbers()
	else if speed == 1
		patchText.text = 'play' if patchText.text != "Jump To"
		hideNumbers()
	else if speed < 1
		patchText.text = 'x' + -speed
		showNumbers()

Utils.delay 2, ->
	recording.video = 'https://ia800207.us.archive.org/10/items/GulliversTravels720p/GulliversTravels1939_512kb.mp4'
	recording.player.play()

hideNumberAnimations = []
hideNumbers = () ->
	stopAnimations()
	for remoteNumbers in remoteNumber
		hideNumber = remoteNumbers.animate
			y:18
			opacity:0
			options:
				curve:'ease-in-out'
				time:0.4
				delay:5
		hideNumberAnimations.push(hideNumber)

showNumbers = () ->
	stopAnimations()
	if playbackBarContainer.isAnimating
		playbackBarContainer.onAnimationEnd ->
			for remoteNumbers in remoteNumber
				remoteNumbers.animate
					y:14
					opacity:0.6
					options:
						curve:'ease-in-out'
						time:0.4
	else
		for remoteNumbers in remoteNumber
			remoteNumbers.animate
						y:14
						opacity:0.6
						options:
							curve:'ease-in-out'
							time:0.4
stopAnimations = () ->
	for hideNumber in hideNumberAnimations
		hideNumber.stop()
showPlaybackBar = () ->
	playbackBarContainer.animate
		opacity:1
		y:0
		options:
			curve:'ease-in-out'
			time:0.5
	topGradient.animate
		opacity:1
		y:0
		options:
			curve:'ease-in-out'
			time:0.5

hidePlaybackBar = () ->
	if recording.player.playbackRate == 1
		playbackBarContainer.animate
			opacity:0
			y:playbackBarContainer.y+20
			options:
				curve:'ease-in-out'
				time:0.5
		topGradient.animate
			opacity:0
			y:-20
			options:
				curve:'ease-in-out'
				time:0.5
		hideNumbers()
