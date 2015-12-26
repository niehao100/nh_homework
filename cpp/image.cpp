/**********************************************************************************
 *
 *     The Seventeenth Tsinghua University Electronical Design Competition
 *                   清华大学第十七届电子设计大赛（上位机程序）
 *    
 *     Author：温拓扑
 *     Date：  2015.9.22
 *     Copyright (c) 2015 温拓扑. All rights reserved.
 *
 *     Filename：   communication.cpp
 *
 ***********************************************************************************/

#include "image.h"

#ifdef DEBUG
double start_timer()//用于计时
{
    double start_time = (double)getTickCount();
    return start_time;
}

double end_timer(double start_time, int num_tests)
{
    double time = (1000 * ((double) getTickCount() - start_time) / getTickFrequency());
    cout << "Average time of " << num_tests << " frames is: " << time / num_tests << " ms" <<endl;
    return time;
}
#endif

Image::Image()
{
    warp_mat = cvCreateMat(2, 3, CV_32FC1);
    Thres_of_block = 70;  //二值化的阈值70
    Thres_of_area = 350;  //过滤的轮廓范围300

    /* 打开摄像头，台式机中0代表 */
    capture = cvCreateCameraCapture(0);

#ifdef DEBUG
    cvNamedWindow("video");
    while (1)
    {
        frame = cvQueryFrame(capture);
        if (!frame)
            break;
        cvShowImage("video", frame);
        if (cvWaitKey(8) == 'c')
        {
            cvSaveImage("testcam1.jpg", frame);
            break;
        }
    }
#endif
    //cvReleaseCapture(&capture);
    //cvReleaseImage(&frame);

    //保存一张用来初始化的图像

    src = cvLoadImage("testcam1.jpg",0);
    dst = cvCreateImage(cvGetSize(src), src->depth, src->nChannels);
#ifdef DEBUG
    cvShowImage("black", src);
    cvWaitKey(0);
#endif
    //摄像头矫正
    intrinsic = (CvMat*)cvLoad("cameraMatrix.xml");
    distortion = (CvMat*)cvLoad("distCoeffs.xml");
    mapx = cvCreateImage(cvGetSize(src), IPL_DEPTH_32F, 1);

    mapy = cvCreateImage(cvGetSize(src), IPL_DEPTH_32F, 1);

    //计算内参矩阵
    cvInitUndistortMap(intrinsic, distortion, mapx, mapy);
    //校正
    cvRemap(src, dst, mapx, mapy);
#ifdef DEBUG
    cvNamedWindow("jibian");
    cvShowImage("jibian", dst);
    cvWaitKey(0);
#endif

    int success = 0;
    double area = 100000000.0;
    CvMemStorage* storage = cvCreateMemStorage(0);
    CvMemStorage* storage1 = cvCreateMemStorage(0);//储存轮廓的内存
    CvSeq* contour = 0;
    CvSeq* polycontour = 0;
    CvSeq* tmp[3];
    CvBox2D Box;
    CvBox2D Boxtemp;

    cvThreshold(dst, dst, Thres_of_block, 255, CV_THRESH_BINARY);
    cvDilate(dst,dst);
    cvErode(dst, dst, NULL,3);
    cvDilate(dst, dst, NULL, 2);
#ifdef DEBUG
    cvNamedWindow("Find");
    cvShowImage("Find", dst);
    while (cvWaitKey(0) != 27)
    {
        break;
    }
#endif

    cvFindContours(dst, storage, &contour,sizeof(CvContour),CV_RETR_LIST,CV_CHAIN_APPROX_NONE,cvPoint(0, 0));
    //CvContourScanner temp_scanner = scanner;
    polycontour = cvApproxPoly(contour,sizeof(CvContour), storage1, CV_POLY_APPROX_DP, cvContourPerimeter(contour)*0.02, 1);

    CvSeq* contourtemp = polycontour;
    while (success < 3) 
    {
        for (;contourtemp != 0; contourtemp = contourtemp->h_next)
        {
#ifdef DEBUG
            //          polycontour = cvApproxPoly(contourtemp, sizeof(CvContour), NULL, CV_POLY_APPROX_DP, cvContourPerimeter(contourtemp)*0.02,0);
            //          cvDrawContours(dst, contourtemp, CV_RGB(255,255,255), CV_RGB(255,255,255),2,1,8);
            printf("%f \n", cvContourArea(contourtemp));
#endif
            Box = cvMinAreaRect2(contourtemp);
            cout<<"Box height and width are "<<Box.size.height<<" "<<Box.size.width<<endl;
            if (cvContourArea(contourtemp)>Thres_of_area && cvContourArea(contourtemp) <= area && fabs(Box.size.height-Box.size.width)<5 )
            {
                int flag = 1;
                for (int j = 0; j < success+1; j++) 
                {
                    if (contourtemp == tmp[j])
                    {
#ifdef DEBUG
                        printf("this point is samllest so far,\nbut it is same as %dth point\n",j);
#endif
                        flag = 0;
                    }
#ifdef DEBUG
                    else
                        printf("diff\n");
#endif
                }
                if (flag == 1)
                {
                    area = cvContourArea(contourtemp);
                    tmp[success] = contourtemp;
                    Boxtemp = Box;
#ifdef DEBUG
                    cvDrawContours(dst, tmp[success], CV_RGB(255,255,255), CV_RGB(255,255,255),0,1,8);
                    cvRectangle(dst, cvPoint(Boxtemp.center.x-10, Boxtemp.center.y-10), cvPoint(Boxtemp.center.x+10,Boxtemp.center.y+10), cvScalar(100),2);
                    printf("this point is smallest so far,\n And it is chosen as %dth point temp\n",success);
#endif
                }
            }
        }
        contourtemp = polycontour;
        cout<<"Boxtemp.center.x,y is "<<Boxtemp.center.x<<","<<Boxtemp.center.y<<endl;
        if (Boxtemp.center.x < dst->width/2 && Boxtemp.center.y < dst->height/2) 
        {
            cvRectangle(dst, cvPoint(Boxtemp.center.x-10, Boxtemp.center.y-10), cvPoint(Boxtemp.center.x+10,Boxtemp.center.y+10), cvScalar(255),2);
            board[0] = cvPoint(Boxtemp.center.x-(Boxtemp.size.width/2), Boxtemp.center.y-(Boxtemp.size.height/2));
            //angle = angle - 1;
        }
        if (Boxtemp.center.x > dst->width/2 && Boxtemp.center.y < dst->height/2) 
        {
            //board[1] = cvPoint(pointx, pointy);
            board[1] = cvPoint(Boxtemp.center.x+(Boxtemp.size.width/2), Boxtemp.center.y-(Boxtemp.size.height/2));
            cvRectangle(dst, cvPoint(Boxtemp.center.x-10, Boxtemp.center.y-10),cvPoint(Boxtemp.center.x+10, Boxtemp.center.y+10),cvScalar(255),2);
        }
        if (Boxtemp.center.x > dst->width/2 && Boxtemp.center.y > dst->height/2)
        {
            //board[2] = cvPoint(pointx, pointy);
            board[2] = cvPoint(Boxtemp.center.x+(Boxtemp.size.width/2), Boxtemp.center.y+(Boxtemp.size.height/2));
            cvRectangle(dst, cvPoint(Boxtemp.center.x-10, Boxtemp.center.y-10),cvPoint(Boxtemp.center.x+10, Boxtemp.center.y+10),cvScalar(255),2);
            //angle = angle -3;
        }

        //      if (Boxtemp.center.x < dst->width/2 && Boxtemp.center.y > dst->height/2)
        //{
        //          //board[2] = cvPoint(pointx, pointy);
        //          board[bonum++] = cvPoint(Boxtemp.center.x-(Boxtemp.size.width/2), Boxtemp.center.y+(Boxtemp.size.height/2));
        //          cvRectangle(dst, cvPoint(Boxtemp.center.x-10, Boxtemp.center.y-10),cvPoint(Boxtemp.center.x+10, Boxtemp.center.y+10),cvScalar(255),2);
        //	angle = angle -4;
        //      }
        //                cvEndFindContours(&scanner);
        success++;
        area = 1000000000.0;
#ifdef DEBUG
        printf("over\n");
#endif
    }
    //   switch(angle)
    //{
    //case 4: {
    //			if (board[0]==)
    //			srcTri[0].x = board[1].x;//0
    //			srcTri[0].y = board[1].y;
    //			srcTri[1].x = board[2].x;//1
    //			srcTri[1].y = board[2].y;
    //			srcTri[2].x = board[0].x;//2
    //			srcTri[2].y = board[0].y;
    //			break;
    //		}
    //case 3: {
    //			srcTri[0].x = board[0].x;//0
    //			srcTri[0].y = board[0].y;
    //			srcTri[1].x = board[1].x;//1
    //			srcTri[1].y = board[1].y;
    //			srcTri[2].x = board[2].x;//2
    //			srcTri[2].y = board[2].y;
    //			break;
    //		}
    //case 2: {
    //			srcTri[0].x = board[1].x;//0
    //			srcTri[0].y = board[1].y;
    //			srcTri[1].x = board[2].x;//1
    //			srcTri[1].y = board[2].y;
    //			srcTri[2].x = board[0].x;//2
    //			srcTri[2].y = board[0].y;
    //			break;
    //		}
    //case 1: {
    //			srcTri[0].x = board[1].x;//0
    //			srcTri[0].y = board[1].y;
    //			srcTri[1].x = board[2].x;//1
    //			srcTri[1].y = board[2].y;
    //			srcTri[2].x = board[0].x;//2
    //			srcTri[2].y = board[0].y;
    //		}

    srcTri[0].x = board[1].x;//0
    srcTri[0].y = board[1].y;
    srcTri[1].x = board[2].x;//1
    srcTri[1].y = board[2].y;
    srcTri[2].x = board[0].x;//2
    srcTri[2].y = board[0].y;
    //    srcTri[3].x = board[3].x;
    //    srcTri[3].y = board[3].y;
    dstTri[0].x = int(abs(src->height-src->width))/2;
    dstTri[0].y = 0;
    dstTri[1].x = src->width - dstTri[0].x;
    dstTri[1].y = dstTri[0].y;
    dstTri[2].x = dstTri[0].x;
    dstTri[2].y = src->height - 1;
    //    dstTri[3].x = src->width - 81;
    //    dstTri[3].y = src->height - 1;
    cvGetAffineTransform(srcTri, dstTri, warp_mat);
#ifdef DEBUG
    cvWarpAffine(dst, src, warp_mat);
    cvNamedWindow("RAW");
    cvNamedWindow("AFFINE");
    cvShowImage("RAW", src);
    cvShowImage("AFFINE", dst);
    while (cvWaitKey(0) != 27) 
    {
        break;
    }
    cvDestroyAllWindows();
#endif

    Num = 4;
    car = new player[Num];

    cvReleaseImage(&dst);
    dst = cvCreateImage(cvGetSize(src), src->depth, 3);
    show = cvCreateImage(cvSize(src->height,src->height), src->depth, 3);
    cvReleaseImage(&src);
    src = cvCreateImage(cvGetSize(dst), dst->depth, 3);
}

Image::~Image()
{
    cvReleaseCapture(&capture);
    cvReleaseImage(&src);
    cvReleaseImage(&dst);
    cvReleaseImage(&mapx);
    cvReleaseImage(&mapy);
    cvReleaseMat(&warp_mat);
    cvReleaseMat(&intrinsic);
    cvReleaseMat(&distortion);
}

void Image::GetInfo()//这样也行
{
    frame = cvQueryFrame(capture);
    cvCopy(frame, src);
    IplImage* temp1 = cvCreateImage(cvGetSize(src), src->depth, show->nChannels);
    cvCopy(src, temp1);
    //dst = cvCreateImage(cvGetSize(src), src->depth, src->nChannels);
    //show = cvCreateImage(cvSize(src->height,src->height), src->depth, src->nChannels);
    cvRemap(src, temp1, mapx, mapy);
    cvWarpAffine(temp1, dst, warp_mat);
    cvSetImageROI(dst, cvRect((src->width-src->height)/2, 0, src->height, src->height));
    cvCopy(dst,show);
    cvResetImageROI(dst);
    uchar H;
    uchar S;
    uchar V;
    IplImage* temp = cvCreateImage(cvGetSize(show), show->depth, show->nChannels);
    cvCvtColor(show, temp, CV_BGR2HSV);

#ifdef DEBUG
    cvShowImage("temp", temp);
#endif

    for (int i = 0; i < Num; i++) 
    {
        car[i].position = cvPoint(0,0);
        car[i].count = 1;
    }  //选手坐标初始化

    for (int y = 0; y < temp->height; y++)
    {
        for (int x = 0; x < temp->width; x++)
        {
            V = temp->imageData[(y * temp->widthStep) + x*3+2];
            S = temp->imageData[(y * temp->widthStep) + x*3+1];
            H = temp->imageData[(y * temp->widthStep) + x*3+0];
            if (((H > 0 && H < 20) || (H < 180 && H > 160))//红
                    && (S < 255 && S > 120)
                    && (V > 120 && V < 255))
            {
                car[0].position.x += x;
                car[0].position.y += y;
                car[0].count++;
            }
            else if (( H > 100 && H < 140)    //蓝
                    && (S < 255 && S > 120)
                    && (V < 255 && V > 120))
            {
                car[1].position.x += x;
                car[1].position.y += y;
                car[1].count++;
            }
            else
            {
                //                temp->imageData[(y*temp->widthStep)+x*3+2] = 0;
                //                temp->imageData[(y*temp->widthStep)+x*3+1] = 0;
                //                temp->imageData[(y*temp->widthStep)+x*3+0] = 0;
            }

        }
    }
    car[0].position.x /= (car[0].count*1.88);//计算平均值
    car[0].position.y /= (car[0].count*1.88);
    car[1].position.x /= (car[1].count*1.88);
    car[1].position.y /= (car[1].count*1.88);

    //        end_timer(start_time,d);
#ifdef DEBUG

    cvRectangle(show, 
            cvPoint(int(1.88*car[0].position.x-10),
                int(1.88*car[0].position.y-10)),
            cvPoint(int(1.88*car[0].position.x+10), 
                int(1.88*car[0].position.y+10)),
            cvScalar(0,0,255) );
    cvRectangle(show, 
            cvPoint(int(1.88*car[1].position.x-10),
                int(1.88*car[1].position.y-10)),
            cvPoint(int(1.88*car[1].position.x+10), 
                int(1.88*car[1].position.y+10)),
            cvScalar(255,0,0) );
    cvNamedWindow("avi");
    cvShowImage("avi", show);
    char c = cvWaitKey(15);
    if (c == 27)
        cvDestroyWindow("avi");

#endif
    cvReleaseImage(&temp1);
    cvReleaseImage(&temp);
    //cvReleaseImage(&dst);
    //cvReleaseImage(&src);
}
