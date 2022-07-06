## Array Notes

### Numbering
The rings of the array are numbered 0-9, beginning at the side of the array furthest from the doors of the lab. Within each ring, the cameras are numbered 1-5 matching the instructions document. The first ring is 1-5, the second ring is 11-15.

### IP addresses
The ip address for each camera is "10.19.2.1##" where ## is the number of the camera (0# for cameras 1-5). Each camera has an interface that can be accessed by entering the ip of the camera in a browser.

### Saving Video
The QNAP storage device can be accessed at the ip:10.19.2.139 in a browser. There are two accounts: admin and camera. Both passwords are 'batlab1234'. Admin can be signed into through the browser. camera is the account the cameras use to sign into. 

The storage device can be mounted in file explorer by going to 'This PC' right-clicking and selecting 'Add a network location'. Then enter `\\10.19.2.139\Public\` as the network address. In the command line one can navigate to the network drive with the command `pushd \\10.19.2.139\Public`

In the Storage pool on this device there is a shared folder called 'Public'. In this folder there is a folder for each camera. This is where the camera videos are saved.

## IO settings
The cameras are setup with one Leader camera and the rest Follower cameras. Signals for syncing are send over the BNC cables (IO1 on the cameras). Start recording on the Leader camera and it sets IO1 output to high, then low when it ends recording. The Follower cameras are set to start recording when IO1 goes high and end when it goes low.

On the I/O Config page of the camera interface, set all settings to be None, False, False. Except for, on the Follower cameras set 

	StartRecording:
		Source: Input 1 (IO1 in)
		Debounce: True
		Invert: False
	StopRecording:
		Source: Input 1 (IO1 in)
		Debounce: True
		Invert: True

And for the Leader Cameras set:

	Output 1 (IO1 out):
		Source: While Recording
		Debounce: True
		Invert: False
		Drive Strength: High (20mA)

## Matlab Scripts to run the array
Each camera can be interfaced with through a webAPI provided by Chronos. Documentation for this API ships with each camera and can be accessed at `http://CameraIP/apidoc/`. 


RunningArray and Libraries folders are the ones that are important. 

If you tell a camera to save while it is still recording or too soon after you stop, it will stall or freeze or crash. Sometimes if it still responding but wont stop recording then run the `trueStopFollower` Function on a camera url. If that doesn't work, or its frozen on another screen, or the screen is just black, run the `rebootCamera` function with the camera number.

When grabbing files from the server. Make sure the drive is mapped and signed in to in order for it to work. 

Function flow: run `setupCameras` to set the IO 


## Calibration steps

 - finish camera holes
 - black calibrate
 - make sure all cameras are focused and at correct aperture
 - Code to calibrate (svoboda)
 - code to auto upload videos to google drive
 - visual hull code
 - code for mesh and position of bat


Process: there is a contradiction in the setting of the camera parameters. Two variables: Aperture size and focus distance, both physically set on the lens of the camera. Aperture Size controls how much light the camera takes in. The lower the aperture the darker the picture, but also the wider the depth of the focus. The Focus adjustment controls how far from the camera the center of focus is. The depth of focus is the distance on either side of the center of focus that is still in focus. 

So the goal is to find the maximum aperture that can still focus on the entire space of the array. Ie. any space >20cm from the wall of the array should be in focus in each camera. 

For this we start with two settings, one is a low light setting and one is a high light setting. 

 1. The low light setting is a larger aperture with less light such that the picture is washed out and there is better contrast btwn the object and the background, but worse depth of focus.
 2. The high light setting is smaller aperture so a darker picture that needs more light to give contrast, but has a better depth of focus. 


### Low Light Process

Using Camera 103. Lights set at 40%
Aperture is set to white dot above the 4, this gives the required depth of field with having the widest aperture (most light into lens).

Analog gain at 6 and digital at 6dB, this give a good contrast without too much noise.
MAX exposure time for brightest light.

Go around to each camera and set the aperture to that and then adjust focus to be correct, then black calibrate. 

Put diffusers in.

## Cameras Now

Go through ring by ring and communicate and set settings