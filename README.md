In this work, we have a radar that captures pictures of the atmosphere every 5
minutes. After some, the observed storm cells are stored as ellipsoids.
We use the Kalman filter as a forecast tool in order to track and predict the
movement of these storm clouds. At the same time we will test Kalman filter under
different parameters to see how it responds and which of these parameters fit better
our storm tracking problem. Kalman filter is ideal for now-casting and will allow you
to model any linear system accurately.

1. The dataset Data.rar is in a comma-separated ASCII file.  The fields are:
Feature number —> Meaningless, just there as a marker
Feature N_Points —> Number of points of the feature, also its area in km^2 as the base data is approximately in 1 km^2 pixels
Center_X —> Cartesian X location of fitted ellipse center
Center_Y —> Cartesian Y location of fitted ellipse center
LON —> Centroid longitude location
LAT —> Centroid latitude location
Orient —> Orientation of the ellipse as computed from angle from horizontal in X direction
Major Axis —> Major axis length (in km)
Minor Axis —> Minor axis length (in km)
Semi_X —> Semimajor axis length in X direction (Cartesian)
Semi_Y —> Semimajor axis length in Y direction (Cartesian)
Rain_0mm_Total —> Sum of all the rain rates in the feature
Rain_Max —> Maximum precipitation rate found in feature
Rain Mean —> Mean precipitation rate of the feature
Rain Variance —> Variance of precipitation rate of the feature
NP > 5 mm —> Number of points in the feature with rain rates exceeding 5 mm/hr
NP >10 mm —> Number of points in the feature with rain rates exceeding 10 mm/hr
NP >25 mm —> Number of points in the feature with rain rates exceeding 25 mm/hr
ND > 1 hr —> Number of points where the duration exceeds 1 hour (EXPERIMENTAL)
ND > 2 hr —> Number of points where the rain duration exceeds 2 hours (EXPERIMENTAL)
ND > 6 hr —> Number of points where the rain duration exceeds 6 hours (EXPERIMENTAL)

You need to download this file to run DisertationOnlyCenter.m and DisertationFullClouds.m.

2. DisertationOnlyCenter.m <--- Here we track only the center of the storm clouds.

3. DisertationFullClouds.m <--- Full Storm cloud tracking
In order to run DisertationFullClouds.m properly you need elipse.m and implicit.m

4. For full display, check my Thesis.pdf
   
