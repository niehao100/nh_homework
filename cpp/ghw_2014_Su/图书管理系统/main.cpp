#include<iostream>
#include<string>
#include<vector>
#include<fstream>
#include "md5.h"
#include "lib.h"
class ALL;
class Views;
int main(void){
	string s=md5("123456"),sname="admin",pwd=md5("");
	int sno=1,bno=-1,bd=0,i=0;
	time_t date;
	vector<Book> blist;
	vector<STU> stmp;
	fstream ifile("lib.dat",ios_base::in);
	if(ifile)  {
		ifile>>pwd;
	}
	ALL all(blist,stmp,pwd);
	if(ifile){
		//导入学生
		ifile>>sno;
		while(sno!=-1){
			ifile>>sname>>pwd;
			all.Addstu(sname,sno);
			all.Change_stu_pwd(pwd,all.Getslist().size()-1);
			ifile>>sno;
		}
		//导入书本
		int who=-2;
		string bname;
		ifile>>who;
		while(who!=-2){
			ifile>>bname;
			all.Addbook(bname);
			ifile>>who;
		}
		//导入借书情况
		ifile>>sno;
		while(sno!=-1){
			ifile>>date>>bno>>bd;
			all.Borrow_book(bno,sno,bd,date);
			ifile>>sno;
		}
	}
	ifile.close();

	Views view;
	int select=42;
	//登录模块
	int user_id=42;
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
		for(i=0;(i<all.Getslist().size())&&(all.Getslist()[i].Getsno()!=user_id);i++);
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
				select=view.Index(i,all);
				switch(select){
				case 1:system("cls"); all.BPrint();cout<<"输入任意键继续：";getchar(); getchar();break;
				case 2: view.Stu_search(all);break;
				case 3: view.Stu_changepwd(i,all);break;
				case 4: goto Begin; break;
				case 5: j=1;break;
				default: cout<<"无效的选项";
					Sleep(1000);
				}
			}
		}
		else{//admin模块
			for(int j=0;j==0;){
				select=view.Admin();
				switch(select){
				case 1: system("cls"); all.BPrint();cout<<"输入任意键继续：";getchar();getchar();break;
				case 2: system("cls"); all.SPrint();cout<<"输入任意键继续：";getchar();getchar();break;
				case 3: view.Admin_check_return(all);cout<<"输入任意键继续：";getchar();getchar();break;
				case 4: view.Admin_Borrow_book(all);break;
				case 5: view.Admin_return_book(all);break;
				case 6: view.Admin_in_book(all);break;
				case 7: view.Admin_del_book(all);break;
				case 8: view.Admin_in_stu(all);break;
				case 9: view.Admin_changepwd(all);break;
				case 0: j=1;break;
				default: cout<<"无效的选项,按任意键继续";
					cin>>select;
				}
			}
		}
		//输出所有信息
		stmp=all.Getslist();
		fstream of("lib.dat",ios_base::out);
		of<<all.Getpasswd()<<endl;
		for(int j=0;j<stmp.size();j++)
			of<<stmp[j].Getsno()<<" "<<stmp[j].Getsname()<<" "<<stmp[j].Getpasswd()<<" ";
		of<<-1<<endl;
		blist=all.Getblist();
		for(int j=0;j<blist.size();j++)
			of<<blist[j].Getwho()<<" "<<blist[j].Getbname()<<" ";
		of<<-2<<endl;
		for(int j=0;j<blist.size();j++){
			if(blist[j].Getinlib()==0){
				of<<blist[j].Getwho()<<" "<<blist[j].Getdate()<<" "<<j<<" "<<(blist[j].Getredate()-blist[j].Getdate())/ 86400<<" ";
			}
		}
		of<<-1;
		of.close();
		return 0;
}
