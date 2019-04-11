## EXTERNAL
A folder, which is used by the graphical user interface to execute different implementations of image registration procedures. The path to the "external" folder can be re-configured in the "configureGui.m" Matlab file.

### PROJECT STRUCTURE

#### RIGID
A folder, which contains the implementation of the **rigid registration** procedure for 3D medical images. 

###### How to run the rigid procedure?
* Install and configure the free/open-source [NLOPT](https://nlopt.readthedocs.io/en/latest/#download-and-installation) library.
* Change the path to the NLOPT library inside the "rigidRegistration.m" file:

```
% NLopt configuration files
path(path,'/my/custom/path/to/the/NLOPT/library');
```

* Run the "rigidRegistration" in the Matlab Command Window:

```
MATLAB: >> rigidRegistration
```

#### NONRIGID
A folder, which contains the implementation of the **nonrigid b-spline registration** procedure for 3D medical images.

###### How to run the nonrigid procedure?
* Install and configure the free/open-source [NLOPT](https://nlopt.readthedocs.io/en/latest/#download-and-installation) library.
* Change the path to the NLOPT library inside the "rigidRegistration.m" file:

```
% NLopt configuration files
path(path,'/my/custom/path/to/the/NLOPT/library');
``` 

* Install [MEX compiler](https://www.mathworks.com/help/matlab/matlab_external/what-you-need-to-build-mex-files.html).
* Run the below command in the Matlab Command Window:

```
MATLAB: >> /nonrigid/compile
```

* Run the "nonrigidRegistration" in the Matlab Command Window:

```
MATLAB: >> nonrigidRegistration
```

#### METRICS
A folder which contains lower level processing functions, that can be used to compute the **similarity measure** between the reference and the moving image. 
