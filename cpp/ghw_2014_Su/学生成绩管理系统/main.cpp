#include<iostream>
#include<string>
#include<vector>
#include<fstream>
#include "md5.h"
#include "stu.h"
class ALL;
int main(void){
	string s=md5(""),sname="nh",pwd=md5("");
	int sno=2013011280;
	fstream ifile("stu.dat",ios_base::in);
	if(ifile)  {
		ifile>>s>>sno>>sname>>pwd;
	}
	ALL all(s,sname,sno,pwd);
	if(ifile){
		//导入学生
		ifile>>sno;
		while(sno!=-1){
			ifile>>sname>>pwd;
			all.Insertstu(sname,(all.Getslist())[0].Getclist(),sno);
			all.Change_stu_pwd(pwd,all.Getslist().size()-1);
			ifile>>sno;
		}
		//导入课程
		int credit=0;
		string cname;
		ifile>>credit;
		while(credit!=-1){
			ifile>>cname;
			for(int i=0;i<all.Getslist().size();i++){
				all.Insertcourse(i,cname,(char)credit);	
			}
			ifile>>credit;
		}
		//导入成绩
		int j=0,k=0;
		double grade;
		ifile>>j;
		while(j!=-1){
			ifile>>k;
			for(int n=0;(n<all.Getslist()[0].Getclist().size())&&(k!=-3);n++){
				ifile>>grade;
				all.Inputgrade((unsigned char)k,grade,j,n);
				ifile>>k;
			}
			ifile>>j;
		}
	}


	Views view;
	int select=42;
	//登录模块
	int user_id=42,i=0;
Begin:  for(char check=0;check==0;){	
	user_id=view.Login();
	if(user_id==0) {
		char a=0;
		while (a!='\n'){a= getchar();}
		cout<<"请输入密码:";
		string s=view.Inputpasswd();
		check=all.Checkpasswd(s);
	}
	else{
Stu:			for(i=0;(i<all.Getslist().size())&&(all.Getslist()[i].Getsno()!=user_id);i++);
		if(i!=all.Getslist().size()){
			cout<<"请输入密码:";
			string s=view.Inputpasswd();
			check=all.Getslist()[i].Checkpasswd(s);
		}
		else {
			cout<<"用户不存在";
			Sleep(1000);
			goto Begin;
		}
	}
	if(check==0) {
		cout<<"\n密码输入错误\n";
		Sleep(1000);
	}
		}
		//STU模块
		if(user_id!=0){
			for(int j=0;j==0;){
				select=view.Index();
				switch(select){
				case 1: view.Stu_showgpa(i,all.Getslist()); break;
				case 2: view.Stu_showgrade(i,all.Getslist());break;
				case 3: view.Stu_showrank(user_id,all);break;
				case 4: view.Stu_showpass(i,all.Getslist());break;
				case 5: view.Stu_changepwd(i,all);break;
				case 6: goto Begin; break;
				case 7: j=1;break;
				default: cout<<"无效的选项";
					Sleep(1000);
				}
			}
		}
		else{//admin模块
			for(int j=0;j==0;){
				select=view.Admin();
				switch(select){
				case 1: view.Admin_showrank(all);break;
				case 2: view.Admin_showavegpa(all);break;
				case 3: view.Admin_show_all_course(all.Getslist()[0].Getclist());break;
				case 4: view.Admin_show_all_stu(all.Getslist());break;
				case 5: view.Admin_show_all_stu(all.Getslist());
					cout<<"请选择相应的学生:";
					cin>>user_id;
					goto Stu;
					break;
				case 6: view.Admin_in_grade(all);break;
				case 7: view.Admin_in_course(all);break;
				case 8: view.Admin_in_stu(all);break;
				case 9: view.Admin_changepwd(all);break;
				case 0: j=1;break;
				default: cout<<"无效的选项,按任意键继续";
					cin>>select;
				}
			}
		}
		//输出所有信息
		vector<STU> stmp=all.Getslist();
		fstream of("stu.dat",ios_base::out);
		of<<all.Getpasswd()<<endl;
		for(int j=0;j<stmp.size();j++)
			of<<stmp[j].Getsno()<<" "<<stmp[j].Getsname()<<" "<<stmp[j].Getpasswd()<<" ";
		of<<-1<<endl;
		for(int k=0;k<stmp[0].Getclist().size();k++)
			of<<(int)(stmp[0].Getclist()[k].Getcredit())<<" "<<stmp[0].Getclist()[k].Getcname()<<" ";
		of<<-1<<endl;
		for(int j=0;j<stmp.size();j++){
			of<<j<<" ";
			for(int k=0;k<stmp[j].Getclist().size();k++){
				of<<(int)stmp[j].Getclist()[k].Getpass()<<" "<<stmp[j].Getclist()[k].Getgrade()<<" ";
			}
			of<<-3<<endl;
		}
		of<<-1;
		of.close();
		return 0;
}
