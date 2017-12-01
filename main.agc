
// Project: plane test 
// Created: 2017-11-06

dim speed1 [ 1000 ] as float

// show all errors
SetErrorMode(2)

// set window properties
SetWindowTitle( "plane test" )
SetWindowSize( 1334, 750, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

// set display properties
SetVirtualResolution( 1334, 750 ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 ) // since version 2.0.22 we can use nicer default fonts
SetClearColor(0, 200, 255)
SetPrintSize(20)

// Setting displaycentre values as constants
#constant displayCentreX 	= 1334/2
#constant displayCentreY 	= 750/2

// Ground value for Sprite/Image ID numbers
ground = 2
explosion = 3
gameover = 4

// Plane values
plane = 1
planex = 600
planey = GetVirtualHeight() - 110
planeang = 0
speed = 0

// Creating and positioning plane
LoadImage(plane, "plane.png")
LoadImage(explosion, "explosion.png")
CreateSprite(plane, plane)
//SetSpriteScale(plane, 0.5, 0.5)
SetSpritePosition(plane, planex, planey)

// Creating and positioning game over screen
LoadImage(gameover, "gameover.png")
CreateSprite(gameover, gameover)
SetSpriteScale(gameover, 2, 2)
SetSpritePosition(gameover, GetVirtualWidth()/2 - GetSpriteWidth(gameover)/2, GetVirtualHeight()/2 - 200)
SetSpriteDepth(gameover, 1)
SetSpriteVisible(gameover, 0)

// Creating and positioning ground
LoadImage(ground, "ground.jpg")
CreateSprite(ground, ground)
SetSpritePosition(ground, -650, GetVirtualHeight()-60)
SetSpriteScale(ground, 10, 1)

// Creating throttle sprite as text
CreateText(10, str(speed))
CreateText(11, "Speed:")

// Creating clouds
LoadImage(70, "cloud.png")
for i = 50 to 500
	
	CreateSprite ( i, 70 )
    SetSpritePosition ( i, Random ( 0, 133400 ), Random ( -1000, GetVirtualHeight()-60 ) )


    size = Random ( 3, 10 ) / 10.0
    SetSpriteScale ( i, size, size )
    SetSpriteDepth(i, 100)

	
next i

do
	for i = 50 to 500
        SetSpriteX ( i, GetSpriteX ( i ) - speed1 [ i ] )


        if ( GetSpriteX ( i ) < -20 )
            SetSpritePosition ( i, Random ( 330, 400 ), Random ( 0, 10000 ) )
            speed1 [ i ] = Random ( 1, 30 ) / 10.0
        endif
    next i
	
	dead = 0
	
    // Throttle
    if GetRawKeyState(38) = 1
		speed = speed + 1
	endif
	if GetRawKeyState(40) = 1
		speed = speed - 1
	endif
	
	// Max speed and min speed
	if speed > 600
		speed = 600
	endif
	if speed < 0
		speed = 0
	endif
	
	
	// If speed is greater than v1(100) and left/right arrows pressed, change angle
	if GetRawKeyState(37) = 1 and speed >= 100
		planeang = planeang - 1
	endif
	if GetRawKeyState(39) = 1 and speed >= 100
		planeang = planeang + 1
	endif
	
	// Max plane angle and min plane angle
	if planeang > 20
		planeang = 20
	endif
	
	if planeang < -20
		planeang = -20
	endif
	
	
	// plane speed calculations
	planex = planex + speed/10
	
	// Plane y value calculations based on angle and speed
	planey = planey + planeang/2
	
	// Determine when dies !!!! WILL BE CHANGED LATER
	if planex < 1600 or planey > 6600
		if planey > GetVirtualHeight()-GetSpriteHeight(plane)-60
			planey = GetVirtualHeight()-GetSpriteHeight(plane)-60
			planeang = 0
		endif
	else
		if planey > GetVirtualHeight()-GetSpriteHeight(plane)-60
			planey = GetVirtualHeight()-GetSpriteHeight(plane)-60
			speed = 0
			planeang = 0
			planex = 0
			
			dead = 1
			
			// Plays explosion animation
			SetSpriteImage(plane, explosion)
			SetSpriteAnimation(plane, 100, 100, 75)
			PlaySprite(plane, 60, 0, 1, 75)
			
			// Removes ground
			SetSpriteVisible(ground, 0)
			
			// Displays game over screen
			SetSpriteVisible(gameover, 1)
			SetSpriteScale(gameover, 2.5, 2.5)
			SetSpritePosition(gameover, planex-GetSpriteWidth(gameover)/2.2, planey-GetSpriteHeight(gameover)/1.5)
		endif
	endif
	
	/*
	SetSpritePhysicsOn(plane, 2)
	SetPhysicsGravity(0, 1000000)
	*/
	
	// Setting plane angle and position
	SetSpriteAngle(plane, planeang)
	SetSpritePosition(plane, planex, planey)
	
	SetTextSize(11, 50)
	SetTextPosition(11, planex - 500, planey - 50)
	
	SetTextString(10, str(speed))
	SetTextSize(10, 50)
	SetTextPosition(10, planex - 500, planey)
	
	
	PrintC("Test Values: ")
	PrintC("Speed: ")
	printC(speed)
	PrintC("Angle: ")
	Print(-planeang)
    
    // Camera that follows plane sprite
    SetViewOffset(GetSpriteXByOffset(plane) - displayCentreX, GetSpriteYByOffset(plane) - 375)
    SetViewZoomMode(1)
    SetViewZoom(3)
    
    if dead = 1
		
	endif
    
    Sync()
loop


