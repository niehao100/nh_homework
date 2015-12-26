/************************************************************************************
*
*     The Seventeenth Tsinghua University Electronical Design Competition
*                   清华大学第十七届电子设计大赛（上位机程序）
*    
*     Author：温拓朴
*     Date：  2015.9.22
*     Copyright (c) 2015 温拓朴. All rights reserved.
*
*     Filename：   image.h
*     Discription：This file contains the functions of image group,they can return 
*                  the coordation of players and the image of the camera.
*                  
***********************************************************************************/

#ifndef __testopencv__image__
#define __testopencv__image__

#define DEBUG
#include <cxcore.h>
#include <iostream>
#include <cv.h>
#include <highgui.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <ctime>

using namespace std;
using namespace cv;

struct player
{
    CvPoint position;
    int count;
};

class Image
{
private:
    CvPoint board[3];
    CvPoint2D32f srcTri[3];
    CvPoint2D32f dstTri[3];
    CvMat* intrinsic;      //用于摄像头校正的矩阵
    CvMat* distortion;
    IplImage* mapx;
    IplImage* mapy;
    CvMat* warp_mat;
    CvCapture* capture;
    //需要现场调试的参数
    int Thres_of_block;//二值化的阈值
    int Thres_of_area;//过滤的轮廓范围
	int Thres_of_area2;//upperboard
    
public:
    player* car;
    int Num;//选手的参赛选手的个数
    IplImage* frame;
    IplImage* src;//原图像
    IplImage* dst;
    IplImage* show;
    Image();//包含棋盘图像的获取(棋盘图像只需要读取前期的数值即可)，矫正之后进行三对点的识别，计算出warp_mat
    ~Image();//
    void GetInfo();
};


#endif /* defined(__testopencv__image__) */
