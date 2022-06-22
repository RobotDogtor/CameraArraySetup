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

