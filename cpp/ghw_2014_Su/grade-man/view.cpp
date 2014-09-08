#include<iostream>
#include<stdio.h>
#include<string>
#include<stdlib.h>
//#include<conin.h>//for windows
#include "md5.h"
using namespace std;
string Inputpasswd(){
	char temp_c=42,length=0;
	string passwd="";
	for(;;){
		system("stty -echo");//for linux
		temp_c=getchar();
		system("stty echo"); //for linux
		if(temp_c!='\n'){
			switch(temp_c){
				case 8:
					if(length!=0){
						cout<<"/b /b";
						passwd=passwd.substr(0,length-1);
						length--;
					}
				break;

				default:
				cout<<"";
				passwd+=temp_c;
				length++;
				break;
			}
		}
		else break;
	}
	return md5(passwd);
}
int main (void){
	cout<<"input"<<endl;
	cout<<Inputpasswd();
	return 0;
}
