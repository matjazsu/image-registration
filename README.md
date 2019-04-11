## IMAGE REGISTRATION ENVIRONMENT

Image registration environment for Matlab improves the implementation of image registration procedures. It includes a graphical user interface that simplifies testing and application of image registration procedures as well as their development by incorporating a large set of lower level processing functions.

### PROJECT STRUCTURE

#### GUI:
A graphical user interface that simplifies work with medical images and registration techniques. It allows loading 3D images in different file formats like DICOM, BrainWeb and RIRE (Retrospective Image Registration Evaluation project). It provides a slice by slice visualization, image statistics like histograms and comparison of geometric relations between images. The graphical user interface also allows exporting and importing the described data structure in order to provide the capability to save temporary results that can be reused in future. One of the main features of the graphical user interface is to load and execute different image registration procedures. This feature simplifies and improves the testing phase of the development process.

###### How to run the graphical user interface? 
* Run the below command in the Matlab Command Window:

```
MATLAB: >> runGui
```

#### TOOLBOX: 
A large set of lower level processing functions, that were implemented in past research activities. They can be used by the GUI or directly in the Matlab workspace.

###### How to compile ".cpp" functions inside the toolbox folder?
* Install [MEX compiler](https://www.mathworks.com/help/matlab/matlab_external/what-you-need-to-build-mex-files.html).
* Run the below command in the Matlab Command Window:

```
MATLAB: >> /toolbox/compile
```

#### EXTERNAL:
A folder, which is used by the graphical user interface to execute different implementations of image registration procedures. The path to the "external" folder can be re-configured in the "configureGui.m" Matlab file.

###### How to re-configure the path to the "external" folder?
* Change the value of "GUI.external.path" property inside the 
"configureGui.m" file:

```
GUI.external.path = '/my/custom/path/to/the/external/folder/'
```

#### DATA:
A folder, which is used to store examples of medical images.