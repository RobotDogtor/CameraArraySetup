# CameraArraySetup


#MultiCam Self Cal

Way it works is that it loads all the data points for all the cameras then it goes through and finds all pairs of cameras that share points and makes sure that there are at least 8 data points for each pair. Then it goes through random samples of 7 data points for each pair.

Had to make sure there were enough data points for each pair.
Made it so that a degraded sample is just skipped.
make sure each camera has points


## Process for working with array
Start with all cameras off. then turn them on and let them boot up. Run Find Problem cameras to find the ones that are not communicating. 
Disconnect from internet
Reboot all problem cameras, by command first and then hard reset by turning off power. 
Keep going until the cameras work and then once they do they should for a while. 
If you get into recording looping, then power reset the entire array. 