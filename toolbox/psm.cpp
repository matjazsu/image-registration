#include <math.h>
//#include <matrix.h> //PRJ 2017-05-05
#include <mex.h>

//-------------
#include <iostream>
#include <stdint.h>
#include "mexcpp.h"  //see https://github.com/kuitang/mexcpp
using namespace mexcpp;

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    /* Input parameters:
        - REG structure with loaded images
        - point similarity function
        Return:
        - estimaated similarity for the given region using point similarity principle
    */
    if (nrhs!=2) 
        mexErrMsgTxt("Required input paremeters: REG structure, point similarita function (PSF)!");
    if(!mxIsStruct(prhs[0]))
        mexErrMsgTxt("First input parameter must be a structure!");
    
    // read refIdx and movIdx:
    //------------------------
    StructMat sm(prhs[0]);
    int refIdx  = sm.getS<int32_t>("refIdx")-1;
    int movIdx  = sm.getS<int32_t>("movIdx")-1;
    //mexPrintf("refIdx: %d , movIdx: %d\n", refIdx+1, movIdx+1);
        
    
    mxArray *img;
    if ((img = mxGetField(prhs[0], 0, "img"))==NULL) mexErrMsgTxt("Invalid REG structure, missing images img!");
    //=====================================================================
    //define variables:
    
    bool Transf, Deform; 
    int NXR,NYR,NZR,NXYR,NXYZR, NXO,NYO,NZO,NXYZO;
    float OXR,OYR,OZR, OXO,OYO,OZO;
    float SXR,SYR,SZR, SXO,SYO,SZO;
    float *pDXO0,*pDYO0,*pDZO0;
    float *pDXO,*pDYO,*pDZO;
    float *pT, *pTtmp;
    uint8_t *pMR, *pMR0,*pMO,*pMO0;
    double *pPSF0;
    double *pPsfO; //tmp pointer to the psf row for given intensity of O (moving image/object)
    
    
    //=====================================================================
    //Get reference image data: img(refIdx).{voxelSize,data, O,D,T}
    //voxel size:
    mxArray *myarray;
    if ((myarray = mxGetField(img, refIdx, "voxelSize"))==NULL) mexErrMsgTxt("Voxel size dimmension of the reference image is not defined!");
    size_t voxSizeDim = mxGetNumberOfElements(myarray);    
    if (voxSizeDim!=3) mexErrMsgTxt("Invalid voxel size dimmension of ref. img, must be 3!");
    if (!mxIsSingle(myarray)) mexErrMsgTxt("Invalid data type of the ref img voxelSize, must be single!");
    float *voxSize = (float*)mxGetData(myarray);
    SXR=voxSize[0]; SYR=voxSize[1]; SZR=voxSize[2];    
    //mexPrintf("voxSizeR: %f x %f x %f\n", SXR, SYR, SZR);
    
    if ((myarray = mxGetField(img, movIdx, "voxelSize"))==NULL) mexErrMsgTxt("Voxel size dimmension of the moving image is not defined!");
    voxSizeDim = mxGetNumberOfElements(myarray);    
    if (voxSizeDim!=3) mexErrMsgTxt("Invalid voxel size dimmension of moving img, must be 3!");
    if (!mxIsSingle(myarray)) mexErrMsgTxt("Invalid data type of the moving img voxelSize, must be single!");
    voxSize = (float*)mxGetData(myarray);
    SXO=voxSize[0]; SYO=voxSize[1]; SZO=voxSize[2];
    //mexPrintf("voxSizeO: %f x %f x %f\n", SXO, SYO, SZO);
    
    // O- origin ----------------------------------------------------------
    float *O;
    myarray = mxGetField(img, refIdx, "O");
    if (myarray==NULL) { // origin is (0,0,0) 
        OXR=0; OYR=0; OZR=0;
    }
    else {
        size_t dim = mxGetNumberOfElements(myarray);    
        if (dim!=3) mexErrMsgTxt("Invalid origin dimmension of ref. img, must be 3!");       
        if (!mxIsSingle(myarray)) mexErrMsgTxt("Invalid data type of the ref img origin (O), must be single!");
        O = (float*)mxGetData(myarray);
        OXR=O[0]; OYR=O[1]; OZR=O[2];
    }
    //mexPrintf("Reference origin: %f x %f x %f\n", OXR, OYR, OZR);
    
    myarray = mxGetField(img, movIdx, "O");
    if (myarray==NULL) { // origin is (0,0,0) 
        OXO=0; OYO=0; OZO=0;
    }
    else {
        size_t dim = mxGetNumberOfElements(myarray);    
        if (dim!=3) mexErrMsgTxt("Invalid origin dimmension of moving img, must be 3!"); 
        if (!mxIsSingle(myarray)) mexErrMsgTxt("Invalid data type of the moving img origin (O), must be single!");
        O = (float*)mxGetData(myarray);
        OXO=O[0]; OYO=O[1]; OZO=O[2];
    }
    //mexPrintf("Moving image origin: %f x %f x %f\n", OXO, OYO, OZO);
    
    // data - pointers and image size (in voxels) -------------------------
    if ((myarray = mxGetField(img, refIdx, "data"))==NULL) mexErrMsgTxt("Image data of ref. img is not defined!");
    if (!mxIsUint8(myarray)) mexErrMsgTxt("Invalid data type of the ref. img data, must be uint8!");
    const mwSize *dataSize = mxGetDimensions(myarray);
    NXR=dataSize[0]; NYR=dataSize[1]; NZR=dataSize[2];
    NXYR=NXR*NYR; NXYZR=NXYR*NZR;
    //mexPrintf("Ref data size: %d x %d x %d\n", NXR, NYR, NZR); 
    pMR0 = (uint8_t*)mxGetData(myarray);
    //mexPrintf("initial ref data : %d x %d x %d\n", pMR0[0], pMR0[1], pMR0[2]);
    
    if ((myarray = mxGetField(img, movIdx, "data"))==NULL) mexErrMsgTxt("Image data of moving img is not defined!");
    if (!mxIsUint8(myarray)) mexErrMsgTxt("Invalid data type of the moving img data, must be uint8!");
    dataSize = mxGetDimensions(myarray);
    NXO=dataSize[0]; NYO=dataSize[1]; NZO=dataSize[2];
    NXYZO=NXO*NYO*NZO;
    //mexPrintf("Moving img data size: %d x %d x %d\n", NXO, NYO, NZO); 
    pMO0 = (uint8_t*)mxGetData(myarray);
    //mexPrintf("initial moving data : %d x %d x %d\n", pMO[0], pMO[1], pMO[2]);
    
    // T - transformation of the moving image -----------------------------
    if ((myarray = mxGetField(img, movIdx, "T"))==NULL) {
        Transf=false;
    } else {
        dataSize = mxGetDimensions(myarray);
        if (dataSize[0]!=4 || dataSize[1]!=4) {
            if (mxGetNumberOfElements(myarray))
                mexErrMsgTxt("Invalid transformation T of moving img, must be 4x4");
            else {
                Transf=false;
            }
        }
        else {
            if (!mxIsSingle(myarray)) mexErrMsgTxt("Invalid data type of the moving img T, must be single!");
            pT=(float*)mxGetData(myarray);
            Transf=true;
        }
    }
    
    // D - deformation field of the moving image --------------------------
    if ((myarray = mxGetField(img, movIdx, "D"))==NULL) {
        Deform=false;
    } else {
        if (mxGetNumberOfElements(myarray)) {
            dataSize = mxGetDimensions(myarray);
            if (dataSize[0]!=NXR || dataSize[1]!=NYR || dataSize[2]!=NZR) {
                mexPrintf("Invalid size of the deformation field D: %d, %d, %d\n", dataSize[0], dataSize[1], dataSize[2] );
                Deform=false;
            } else {
                if (!mxIsSingle(myarray)) mexErrMsgTxt("Invalid data type of the moving img deformation field (D), must be single!");
                pDXO0=(float*)mxGetData(myarray);
                pDYO0= pDXO0+NXYZO;
                pDZO0= pDYO0+NXYZO;
                Deform=true;
            }
        } else {
            Deform=false;
        }
    }
    
    // T and D of the reference image--------------------------------------
    if ((myarray = mxGetField(img, refIdx, "T"))!=NULL) {
        if (mxGetNumberOfElements(myarray)) {
            mexErrMsgTxt("The reference image must not be tronsformedand (T)!\n");
        }
    }
    
    // D - deformation field of the moving image --------------------------
    if ((myarray = mxGetField(img, movIdx, "D"))==NULL) {
        if (mxGetNumberOfElements(myarray)) {
            mexErrMsgTxt("The reference image must not be deformed (D)!\n");
        }
    }
    
 
    // Masks --------------------------------------------------------------
    uint8_t *pMaskR, *pMaskR0, *pMaskO, *pMaskO0;
    bool maskR=false, maskO=false;
    
    if (myarray = mxGetField(img, refIdx, "mask")) {
        if (mxGetNumberOfElements(myarray)) {   
            if (!mxIsUint8(myarray)) mexErrMsgTxt("Invalid data type of the ref. mask, must be uint8!");
            const mwSize *maskRSize = mxGetDimensions(myarray);
            if (maskRSize[0]!=NXR || maskRSize[1]!=NYR || maskRSize[2]!=NZR) {
                mexErrMsgTxt("Invalid size of the ref. mask, must equal the data size!");    
            }
            pMaskR0 = (uint8_t*)mxGetData(myarray);
            maskR=true;
            //mexPrintf("Using reference mask.\n");
        }
    }
    if (myarray = mxGetField(img, movIdx, "mask")) {
        if (mxGetNumberOfElements(myarray)) {   
            if (!mxIsUint8(myarray)) mexErrMsgTxt("Invalid data type of the moving image mask, must be uint8!");
            const mwSize *maskOSize = mxGetDimensions(myarray);
            if (maskOSize[0]!=NXO || maskOSize[1]!=NYO || maskOSize[2]!=NZO) {
                mexErrMsgTxt("Invalid size of the moving image mask, must equal the data size!");    
            }
            pMaskO0 = (uint8_t*)mxGetData(myarray);
            maskO=true;
            //mexPrintf("Using moving image mask.\n");
        }
    }  
 
    // ROIs ---------------------------------------------------------------
    int *roiR, *roiO; // pointer to arrray with 6 elements (x, X, y, Y, z, Z)
    bool roiRdef=false, roiOdef=false; //whether to use regions of interest (ROIs)
    
    if (myarray = mxGetField(img, refIdx, "ROI")) {
        size_t roiSize=mxGetNumberOfElements(myarray);
        if (roiSize) {   
            if (!mxIsInt32(myarray)) mexErrMsgTxt("Invalid data type of the ref. ROI, must be int32!");
            if (roiSize!=6) {
                mexErrMsgTxt("Invalid size of the ref. ROI, must equal 6 ([x X y Y z Z])!");    
            }
            roiR = (int*)mxGetData(myarray);
            roiRdef=true;
            //mexPrintf("Using reference ROI.\n");
        }
    }
    
    if (myarray = mxGetField(img, movIdx, "ROI")) {
        size_t roiSize=mxGetNumberOfElements(myarray);
        if (roiSize) {   
            if (!mxIsInt32(myarray)) mexErrMsgTxt("Invalid data type of the moving image ROI, must be int32!");
            if (roiSize!=6) {
                mexErrMsgTxt("Invalid size of the moving image ROI, must equal 6 ([x X y Y z Z])!");    
            }
            roiO = (int*)mxGetData(myarray);
            roiOdef=true;
            //mexPrintf("Using moving image ROI.\n");
        }
    }
     
    // PSF ---------------------------------------------------------------
    /*if ((myarray = mxGetField(img, movIdx, "PSF"))==NULL) {
        mexErrMsgTxt("Undefined REG.img(movIdx).PSF!");
    } */
    //prhs[1];
    if ( mxGetNumberOfElements(prhs[1]) != 256*256 ) {
        mexErrMsgTxt("Invalid REG.img(movIdx).PSF! Expected dimension 256 x 256!");
    } 
    if ( !mxIsDouble(prhs[1]) ){
        mexErrMsgTxt("Invalid REG.img(movIdx).PSF! Double precision expected!");
    }    
    pPSF0 = (double*) mxGetData(prhs[1]);
    pPsfO; //tmp pointer to the psf row for given intensity of O (moving image/object)
    
    //=====================================================================
   
    //define the output data
    //plhs[0] = (mxArray *) prhs[0]; // to copy input to putput
    
    // define a new scalar 'sim' - similarity
/*    mxArray *simArr = mxCreateDoubleScalar(0.0);
    
    if (mxGetField(img, movIdx, "sim")==NULL) {
        int nr= mxAddField(img, "sim");
    } 
    mxSetField(img, movIdx, "sim", simArr);
    double *pSim=(double*)mxGetData(simArr);
 */
    if (nlhs<1) 
        mexErrMsgTxt("Return variable(s) is/are not defined! [sim, simWeight]");
    plhs[0] = mxCreateDoubleScalar(0.0);
    double *pSim=(double*)mxGetData(plhs[0]);
    //*pSim=0;
    
    //-- simWeight
    /*
    mxArray *simWArr = mxCreateDoubleScalar(0.0);
    
    if (mxGetField(img, movIdx, "simWeight")==NULL) {
        int nr= mxAddField(img, "simWeight");
    } 
    mxSetField(img, movIdx, "simWeight", simWArr);
    double *pSimW=(double*)mxGetData(simWArr);
    */
    double simW=0; //if not an output variable
    double *pSimW=&simW;
    if (nlhs==2) {
        plhs[1] = mxCreateDoubleScalar(0.0);
        pSimW=(double*)mxGetData(plhs[1]);
    } 
    
    //=====================================================================
    // computation part
    // ====================================================================
    // the principle: sim = sum(sim(v))/N;
    double w=0;
     
  float x,y,z,x1,y1,z1;   //position on undeformed temp and deformed image!
  int X1,Y1,Z1;
  
  int rx=0,rX=NXO,ry=0,rY=NYO,rz=0,rZ=NZO;
  if (roiOdef) {
      rx=std::max(rx, *roiO); roiO++;
      rX=std::min(rX, *roiO); roiO++;
      ry=std::max(ry, *roiO); roiO++;
      rY=std::min(rY, *roiO); roiO++;
      rz=std::max(rz, *roiO); roiO++;
      rZ=std::min(rZ, *roiO); roiO++;
  }
  
  for (int pz=rz;pz<rZ;pz++){      //along all image voxels (imagine undeformed) 
    for (int py=ry;py<rY;py++){
      int move = rx + NXO * (py + NYO * pz);
      pMO  = pMO0 + move;
      if (Deform){
          pDXO = pDXO0 + move;
          pDYO = pDYO0 + move;
          pDZO = pDZO0 + move;      
      } 
      if (maskO){
          pMaskO = pMaskO0 + move;
      }
        
      for (int px=rx;px<rX;px++){
        
          if (maskO){  // check the moving image mask 
            if (*pMaskO) {
                pMaskO++;
            } else {
                pMaskO++;
                pMO++;
                if (Deform){
                  pDXO++;
                  pDYO++;
                  pDZO++;
                }
                continue;
            }      
        }
          
        x=px*SXO-OXO; y=py*SYO-OYO; z=pz*SZO-OZO;
        if (Deform){
          x1=x+*pDXO; pDXO++;
          y1=y+*pDYO; pDYO++;
          z1=z+*pDZO; pDZO++;
        }
        else {
          x1=x;  y1=y;  z1=z;
        }
        if (Transf){            
          x=x1; y=y1; z=z1;
          pTtmp=pT;
          x1=  x**pTtmp; pTtmp++;
          y1=  x**pTtmp; pTtmp++;
          z1=  x**pTtmp; pTtmp++;
          pTtmp++;         
          x1+= y**pTtmp; pTtmp++;
          y1+= y**pTtmp; pTtmp++;
          z1+= y**pTtmp; pTtmp++;
          pTtmp++;
          x1+= z**pTtmp; pTtmp++;
          y1+= z**pTtmp; pTtmp++;
          z1+= z**pTtmp; pTtmp++;
          pTtmp++;
          x1+=   *pTtmp; pTtmp++;
          y1+=   *pTtmp; pTtmp++;
          z1+=   *pTtmp;
        }
        // x1,y1,z1 are now positions in mm.

        //position in reference
        x=(x1+OXR)/SXR;
        y=(y1+OYR)/SYR;
        z=(z1+OZR)/SZR;
        // x,y,z are now postitions in Ref image in voxels
        X1=floor(x);     x1=x-X1;
        Y1=floor(y);     y1=y-Y1;
        Z1=floor(z);     z1=z-Z1;

        // mask & ROI or the reference image!!! (check only the nearest pixel!
        bool inrange=true;

        if (roiRdef) {
            int *roiRtmp=roiR;
            if (*roiRtmp>x) inrange=false; roiRtmp++;  // or is it faster to comapre *roiRmin <= X1 <= *roiRmax-1
            if (*roiRtmp<x) inrange=false; roiRtmp++;
            if (*roiRtmp>y) inrange=false; roiRtmp++;
            if (*roiRtmp<y) inrange=false; roiRtmp++;
            if (*roiRtmp>z) inrange=false; roiRtmp++;
            if (*roiRtmp<z) inrange=false; 
        }
        if (!inrange) {
            pMO++;
            continue;
        }

        
        //pMR=Ref.Data.GetPointer(X1,Y1,Z1);
        pMR=pMR0+ X1 +NXR*(Y1 + NYR * Z1);
        bool bx= ((X1>=0)&&(X1<NXR));
        bool bx1=((X1+1>=0)&&(X1+1<NXR));
        bool by= ((Y1>=0)&&(Y1<NYR));
        bool by1=((Y1+1>=0)&&(Y1+1<NYR));
        bool bz= ((Z1>=0)&&(Z1<NZR));
        bool bz1=((Z1+1>=0)&&(Z1+1<NZR));
        
        bool maskOK;
        if (maskR) pMaskR = pMaskR0 + X1 +NXR*( Y1 + NYR * Z1 );
        
        pPsfO=pPSF0+256**pMO; pMO++;
        if ( bx && by && bz){
            maskOK=true; if ( maskR )  if (!*(pMaskR)) maskOK=false;
            if (maskOK) {
                w = (1-x1)*(1-y1)*(1-z1);
                *pSim += *(pPsfO+*(pMR )) * w;
                *pSimW += w;
                //mexPrintf("000: psf: %f ; w %f \n", *(pPsfO+*(pMR+1+NXR+NXYR )), w);
            }
        } 
        if ( bx1 && by && bz){
            maskOK=true; if ( maskR )  if (!*(pMaskR+1)) maskOK=false;
            if (maskOK) {
              w = (x1)*(1-y1)*(1-z1);
              *pSim += *(pPsfO+*(pMR+1)) * w;
              *pSimW += w;    
            }
        } 
        if ( bx && by1 && bz){
            maskOK=true; if ( maskR )  if (!*(pMaskR+NXR)) maskOK=false;
            if (maskOK) {
              w =  (1-x1)*(y1)*(1-z1);
              *pSim += *(pPsfO+*(pMR+NXR )) * w;
              *pSimW += w; 
            }
        }
        if ( bx1 && by1 && bz){
            maskOK=true; if ( maskR )  if (!*(pMaskR+1+NXR)) maskOK=false;
            if (maskOK)  { 
              w =  (x1)*(y1)*(1-z1);
              *pSim += *(pPsfO+*(pMR+1+NXR )) * w;
              *pSimW += w; 
            }
        }
        if ( bx && by && bz1){
            maskOK=true; if ( maskR )  if (!*(pMaskR+NXYR)) maskOK=false;
            if (maskOK) {
              w =  (1-x1)*(1-y1)*(z1);
              *pSim += *(pPsfO+*(pMR+NXYR )) * w;
              *pSimW += w; 
            }
        }
        if ( bx1 && by && bz1){
            maskOK=true; if ( maskR )  if (!*(pMaskR+1+NXYR)) maskOK=false;
            if (maskOK) {      
              w =  (x1)*(1-y1)*(z1);
              *pSim += *(pPsfO+*(pMR+1+NXYR )) * w;
              *pSimW += w; 
            }
        }
        if ( bx && by1 && bz1){
            maskOK=true; if ( maskR )  if (!*(pMaskR+NXR+NXYR)) maskOK=false;
            if (maskOK) {    
              w =  (1-x1)*(y1)*(z1);
              *pSim += *(pPsfO+*(pMR+NXR+NXYR )) * w;
              *pSimW += w; 
            }
        }
        if ( bx1 && by1 && bz1){
            maskOK=true; if ( maskR )  if (!*(pMaskR+1+NXR+NXYR)) maskOK=false;
            if (maskOK) {   
              w =  (x1)*(y1)*(z1);
              *pSim += *(pPsfO+*(pMR+1+NXR+NXYR )) * w;
              *pSimW += w; 
            }
        } 
        // go to the next voxel of Obj image...
      }
    }
  }

  if (*pSimW>0){
     *pSim = *pSim / *pSimW;
  }
  
}
