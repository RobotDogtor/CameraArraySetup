# CameraArraySetup


#MultiCam Self Cal

Way it works is that it loads all the data points for all the cameras then it goes through and finds all pairs of cameras that share points and makes sure that there are at least 8 data points for each pair. Then it goes through random samples of 7 data points for each pair.

Had to make sure there were enough data points for each pair.
Made it so that a degraded sample is just skipped.
make sure each camera has points