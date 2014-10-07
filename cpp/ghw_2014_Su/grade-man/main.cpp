#include<iostream>
#include<string>
#include<vector>
#include<fstream>
#include "md5.h"
#include "stu.h"
class ALL;
int main(void){
  ALL all;
	Views view;
  char select=42;
//登录模块
  int user_id=42;
Begin:  for(char check=0;check==0;){	
	user_id=view.Login();
	if(user_id==0) 
	check=all.Checkpasswd(view.Inputpasswd());
	else
	check=all.Getslist()[user_id].Checkpasswd(view.Inputpasswd());
	if(check==0) cout<<"\n密码输入错误\n";
	}
//STU模块
	if(user_id!=0){
Stu: for(int i=0;i==0;){
			select=view.Index();
			switch(select){
				case 1: view.Stu_showgpa(user_id,all.Getslist()); break;
			  case 2: view.Stu_showgrade(user_id,all.Getslist());break;
				  case 3: view.Stu_showrank(user_id,all);break;
		      case 4: view.Stu_showpass(user_id,all.Getslist());
				  case 5: goto Begin; break;
				  case 6: i=1;break;
		  	  defalut: cout<<"无效的选项,按任意键继续";
						   cin>>select;
			}
		}
	}
 else{//admin模块
   for(int i=0;i==0;){
		 select=view.Admin();
		 switch(select){
			 case 1: view.Admin_showrank(all);break;
		   case 2: view.Admin_showavegpa(all);break;
			 case 3: view.Admin_show_all_course(all.Getslist()[0].Getclist());break;
			 case 4: view.Admin_show_all_stu(all.Getslist());break;
			 case 5: view.Admin_show_all_stu(all.Getslist());
							 cout<<"请选择需要修改的学生:";
						   cin>>user_id;
							 goto Stu;
							 break;
			 case 6: view.Admin_in_grade(all);break;
			 case 7: view.Admin_in_course(all);break;
			 case 8: view.Admin_in_stu(all);break;
			 case 0: i=1;break;
		   defult: cout<<"无效的选项,按任意键继续";
						   cin>>select;
		 }
	 }
 }
	 return 0;
}

