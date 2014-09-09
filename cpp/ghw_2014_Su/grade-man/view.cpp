#include<iostream>
#include<stdio.h>
#include<string>
#include<stdlib.h>
//#include<conin.h>//for windows
#include "md5.h"
using namespace std;
class VIEWS{
	public:
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
		
		int Login(){
		int name;
		cout<<"**************************************************"
				<<"\n\n\t\t\t\t请输入学号:";//管理员帐号编码0
		cin>>name;
		return name;
		}

	//学生用户登录后的行为	
	char Index(){
		int select=42;
		system("clear"):
		//for win system("cls");	
	cout<<"________________________________________________________\n\n"
		  <<"\t\t欢迎使用学生信息管理系统\n\n"
			<<"________________________________________________________\n\n\n\n"
			<<"1.查询本人GPA\n\n"
			<<"2.查询各科成绩\n\n"
			<<"3.查询本人GPA排名\n\n"
			<<"4.查询本人挂科情况\n\n\n\n"
			<<"5.退出"
			<<"请输入需要的操作：";
  cin>>select;
	return select;
	}	
	void Stu_showgpa(int sno,const vector<STU>& tmp){
		system("clear");
		cout<<tmp[sno-1].Getsname()<<"同学,\n你的GPA为"<<tmp[sno-1].Getgpa();
		char t;
		cout<<"\n\n\n\n\n\n\n\n\t\t\t输入任意键返回";
		cin>>t;
	}
	void Stu_showgrade(int sno,const vector<STU>& tmp){
		system("clear");
		  tmp[sno-1].SPrint;
		char t;
		cout<<"\n\n\n\n\n\n\n\n\t\t\t输入任意键返回";
		cin>>t;
	}
	void Stu_showrank(int sno,const ALL& tmp){
		system("clear");
			vector<STU> rank=tmp.Resort();	
		  for(int i=0;i<rank.size();i++)
			{
				if (rank[i].Getsno()==sno){					
				cout<<rank[i].Getsname()<<"，你的排名为:\t"<<i+1<<endl;
				break;
				}
			}
		char t;
		cout<<"\n\n\n\n\n\n\n\n\t\t\t输入任意键返回";
		cin>>t;
	}		
	void Stu_showpass(int sno,const vector<STU>& tmp){
		system("clear");
		int t[2]={0,0};
		t=tmp[sno-1].Getpass;
		if(t[0]!=0) cout<<tmp[sno-1].Getsname()<<"\n\n\n\n同学，你的挂科数为:"<<t[0]<<"\t挂科学分为:"<<t[1]<<endl;
		char t;
		cout<<"\n\n\n\n\n\n\n\n\t\t\t输入任意键返回";
		cin>>t;
	}
	


		//管理员用户登录后的行为
	char Admin(){
		int select=42;
		system("clear"):
		//for win system("cls");	
	cout<<"________________________________________________________\n\n"
		  <<"\t\t欢迎使用学生信息管理系统\n\n"
			<<"________________________________________________________\n\n\n\n"
			<<"\t\t\t\t查询\n\n\n"
			<<"1.显示成绩排名\n\n"
			<<"2.查询平均GPA\n\n"
			<<"3.显示所有课程\n\n"
			<<"4.显示所有学生\n\n"
			<<"5.查询某学生信息\n\n\n"
			<<"\t\t\t\t修改"
			<<"6.录入成绩"
			<<"7.修改课程信息"
			<<"8.修改学生信息"
			<<"9.修改成绩信息"
			<<"0.退出程序"
			<<"请输入需要的操作：";
  cin>>select;
	return select;
	}
	void Admin_showrank(int sno,const ALL& tmp){
		system("clear");
			vector<STU> rank=tmp.Resort();	
		  for(int i=0;i<rank.size();i++)
			{
				rank[i].SPrint();
				cout<<endl;
			}
		char t;
		cout<<"\n\n\n\n\n\n\n\n\t\t\t输入任意键返回";
		cin>>t;
	}
	void Admin_showavegpa(const ALL& tmp){
		system("clear"):
		cout<<"平均GPA为:"<<tmp.Getavegpa();
		char t;
		cout<<"\n\n\n\n\n\n\n\n\t\t\t输入任意键返回";
		cin>>t;
	}
	void Admin_show_all_course(const vector<Course>& tmp){
		system("clear");
		for(int i=0;i<tmp.size();i++){
			cout<<i+1<<"."<<tmp[i].Getcname();
			if(i%5==4) cout<<endl;
			else cout<<"\t";
		}
		char t;
		cout<<"\n\n\n\n\n\n\n\n\t\t\t输入任意键返回";
		cin>>t;
	}
	void Admin_show_all_stu(const vector<STU>& tmp){
		system("clear");
		for(int i=0;i<tmp.size();i++){
			cout<<tmp[i].Getsname();
			if(i%5==4) cout<<endl;
			else cout<<"\t";
		}
		char t;
		cout<<"\n\n\n\n\n\n\n\n\t\t\t输入任意键返回";
		cin>>t;
  void Admin_in_grade(vector<STU> & tmp);
	void Admin_in_stu(vector<STU> &tmp){
		system("clear");


 };
 void VIEWS::Admin_in_grade(vector<STU> & tmp){
				Admin_show_all_course(tmp[0].Getclist());
				char select1=42,select2=42;
				cout<<"请选择要录入的课程:"<<endl;
				cin>>selecti1;
				cout<<"该课程是否为记通过？[y/n]";
				cout>>select2;
				if(select2=='y'){
					vector<char> grade;
					char g=0;
					for(int i=0;i<tmp.size();i++){
						cout<<tmp[i].Getsno()<<"."<<tmp[i].Getsname()<<":[不及格/及格/良好/优秀]0/1/2/3";
						cin>>g;
						if(g==1||g==2||g==3||g==0)
						grade.push_back=(select*10+g);
						else{
							cout<<"错误的输入"<<endl;
							i--;
						}
					}
				}
				else{
				  vector<double> grade;
					double g=0;
					for(int i=0;i<tmp.size();i++){
						cout<<tmp[i].Getsno()<<"."<<tmp[i].Getsname()<<":";
						cin>>g;
						if(g>=0&&g<=100)
						grade.push_back=(select*101+g);
						else{
							cout<<"错误的输入"<<endl;
							i--;
						}
					}
				}
 }

