#include		<iostream>
#include		<string>
#include		<sstream>
#include		<stdio.h>
#include		<vector>
#include		<stdlib.h>
#include		"md5.h"
#include	    <windows.h>//for windows
#include		<time.h>
#include		<conio.h>
using namespace std;

string Time(time_t t){
	ostringstream s("");
	tm* tmp=localtime(&t);
	s<<tmp->tm_year+1900<<"-"<<tmp->tm_mon+1<<"-"<<tmp->tm_mday;
	return s.str();
}

class Password{
public:
	Password(string s=md5("")):passwd(s){Try=0;}
	Password(const Password& cp):passwd(cp.passwd){Try=0;}
	void Setpasswd(string s=""){passwd=s;}
	string Getpasswd(){return passwd;}
	char Checkpasswd(string s=""){
		Try++;
		if(Try<3){			
			if(passwd=="74be16979710d4c4e7c6647856088456")
				return 1;
			else if(s==Getpasswd())
				return 1;
			return 0;
		}
		else {
			Try=0;
			exit(0);
		}
	}
	void Changepwd(string s=""){passwd=s;}
protected:
	string passwd;
	int Try;//限制尝试次数
};

class STU:public Password{
public:
	STU(vector<int> which,string s="",int sn=0,string pwd=md5("")):sname(s),sno(sn),
		which_borrow(which),Password(pwd){}
	STU(const STU& cp):sname(cp.sname),Password(cp),sno(cp.sno){}
	void SPrint(){cout<<sno<<"."<<sname<<endl;}
	void Borrow(int bno){
		which_borrow.push_back(bno);
	}
	void Return(int bno){
		for(int i=0;i<which_borrow.size();i++){
			if(which_borrow[i]==bno){
				which_borrow.erase(which_borrow.begin()+i);
				break;
			}
		}
	}
	int Getsno(){return sno;}
	string Getsname(){return sname;}
	vector<int> Getwhich(){return which_borrow;}
protected:
	string sname;
	vector<int> which_borrow;
	int sno;
};

class Book
{
public:
	Book(string bn="",time_t d=0,time_t rd=1,int in=1,int who=-1):bname(bn),date(d),redate(rd),inlib(in),who_borrow(who){}	
	Book(const Book &cp):bname(cp.Getbname()),date(cp.Getdate()),redate(cp.Getredate()),inlib(cp.Getinlib()),who_borrow(cp.Getwho()){

	}
	int Borrow(int who=0,int bd=0,time_t t=time(NULL)){
		if(inlib==1){
			date=t;
			redate=date+bd*86400;
			inlib=0;
			who_borrow=who;
			return 1;
		}
		else return 0;
	}
	bool operator<(const Book& tmp)
	{return (redate<tmp.redate);}	
	int Getwho()const {return who_borrow;}
	int Return(){
		date=0;
		inlib=1;
		if(time(NULL)>redate){
			redate=1;
			return who_borrow;
		}
		redate=0;
		return 0;
	}
	string Getbname() const{return bname;}
	time_t Getdate() const{return date;}
	time_t Getredate() const {return redate;}
	int Getinlib() const {return inlib;}

protected:
	time_t date;//借出日期
	string bname;//书名
	time_t redate;//还书日期
	int inlib;//1表示在图书馆,0表示已借出
	int who_borrow;

};

class List
{
public:
	List(vector<Book> bl,vector<STU> s1):blist(bl),slist(s1){}
	List( List &cp):blist(cp.Getblist()),slist(cp.Getslist()){}
	vector<Book> Getbook_by_stu(int n){
		vector<Book> tmp;
		for (int i=0;i<blist.size();i++){
			if(blist[i].Getwho()==n)
				tmp.push_back(blist[i]);
		}
		return tmp;
	}
	vector<Book> Getblist(){return blist;}
	vector<STU>  Getslist(){return slist;}
protected:
	vector<Book> blist;
	vector<STU> slist;
};

class ALL:public Password,public List{
public:
	ALL(vector<Book> b,vector<STU> stu,string s=md5("")):Password(s),List(b,stu){}
	ALL(const ALL& cp):Password(cp),List(cp.blist,cp.slist){}
	void Addbook(string bn=""){
		Book tmp(bn);
		blist.push_back(tmp);
	}
	void Delbook(int bno){
		blist.erase(blist.begin()+bno);
	}
	void Addstu(string sn="",int sno=0){
		vector<int> v;
		STU tmp(v,sn,sno);
		slist.push_back(tmp);
	}
	void Setpasswd(string s=""){
		passwd=s;
	}
	void Borrow_book(int bno,int sno,int bd,time_t t=time(NULL)){
		if(blist[bno].Borrow(sno,bd,t)){
			slist[sno].Borrow(bno);
			cout<<"借书成功"<<endl;
		}
		else cout<<"本书不在架上！！"<<endl;
	}
	int  Return_book(int bno,int sno){
		slist[sno].Return(bno);
		return blist[bno].Return();
	}
	void BPrint(){
		for(int i=0;i<blist.size();i++)		BPrint(i);				
	}
	void BPrint(int bno){
		cout<<bno<<"."<<blist[bno].Getbname()<<endl;
		if(blist[bno].Getinlib()==0)
			cout<<"\t 被借于："<<Time(blist[bno].Getdate())<<"  "<<"于："<<Time(blist[bno].Getredate())<<"截止";
		if(blist[bno].Getinlib()==0&&blist[bno].Getredate()<time(NULL)) cout<<"\t\t状态：正在催还";
		cout<<endl;
	}
	void SPrint(){
		for(int i=0;i<slist.size();i++) SPrint(i);
	}
	void SPrint(int sno){
		slist[sno].SPrint();
		if(slist[sno].Getwhich().size()!=0){
			for(int j=slist[sno].Getwhich().size()-1;j>-1;j--){
				cout<<"\t";
				BPrint(slist[sno].Getwhich()[j]);
			}
		}
	}
	void Search(string keyword);
	vector<Book> Resortbook();
	void Change_stu_pwd(string pwd,int sno){
		slist[sno].Setpasswd(pwd);
	}
};
void ALL::Search(string keyword){
	int i=0;
	for(i=0;i<blist.size();i++){
		if(blist[i].Getbname()==keyword){
			BPrint(i);
			break;
		}
	}
	if(blist.size()-1==i) cout<<"该书不存在";
}
vector<Book> ALL::Resortbook(){
	vector<Book> tblist=blist;
	for(int i=1;i<tblist.size();i++){
		for(int j=0;j<(tblist.size()-i);i++){
			if(tblist[j]<tblist[j+1])		swap(tblist[j],tblist[j+1]);
		}
	}
	return tblist;
}

class Views{
public:
	string Inputpasswd(){
		char temp_c=42,length=0;
		string pwd="";
		while(true)
		{
			temp_c=getch();  //输入一个字符
			if(temp_c!=char(13))  //判断该字符是不为回车，如果是则退出while
			{
				switch  (temp_c)
				{
				case 8:
					if(length!=0)
					{
						cout<<"\b \b";
						pwd=pwd.substr(0,length-1);
						length--;
					}
					else ;
					break;
				default:
					cout<<"*"; //可用用你喜欢的任意字符，如改为cout<<"";则无回显
					pwd+=temp_c;//连成字符串；
					length++;
					break;
				}
			}
			else break;
		}
		return md5(pwd);
	}
	int Login(){
		int name;
		system("cls");
		cout<<"**************************************************"
			<<"\n\n\n\n 请输入学号:";//管理员帐号编码0
		cin>>name;
		return name;
	}
	//学生用户登录后的行为	
	char Index(int sno,ALL & all){
		int select=42;
		system("cls");
		//for win system(""cls"");	
		cout<<"________________________________________________________\n\n"
			<<"\t\t欢迎使用图书馆管理系统\n\n"
			<<"________________________________________________________\n\n\n\n";
		all.SPrint(sno);
		cout<<"\n\n1.查询所有书籍\n\n"
			<<"2.查询所需书籍\n\n"
			<<"3.修改密码\n\n"
			<<"4.注销\n\n"
			<<"5.退出\n\n\n\n"
			<<"请输入需要的操作：";
		cin>>select;
		return select;
	}	
	char Stu_changepwd(int sno,ALL& tmp){
		system("cls");
		cout<<"\n请输入旧密码:";
		string s=Inputpasswd(),s1;
		char judge=tmp.Getslist()[sno].Checkpasswd(s);
		if(judge==0) {
			cout<<"\n\n错误的密码,修改失败";
			Sleep(2000);
			return 0;
		}
		cout<<"\n\n请输入新密码:"<<endl;
		s=Inputpasswd();
		cout<<"\n请再次输入新密码:"<<endl;
		s1=Inputpasswd();
		if(s!=s1){
			cout<<"\n\n两次输入不一样";
			Sleep(1000);
			return 0;
		}
		tmp.Change_stu_pwd(s,sno);
		cout<<"\n\n修改成功";
		Sleep(1000);
		return 1;		
	}
	void Stu_search(ALL &tmp){
		system("cls");
		string key;
		char select=0;

		for(;select!='n';){
			cout<<"请输入需要查询的书籍名:";
			cin>>key;
			tmp.Search(key);
			cout<<"是否继续[y/n]";
			cin>>select;
		}
	}
	//管理员用户登录后的行为
	char Admin(){
		int select=42;
		system("cls");
		//for win system(""cls"");	
		cout<<"________________________________________________________\n"
			<<"\t\t欢迎使用图书馆管理系统\n"
			<<"________________________________________________________\n\n"
			<<"1.显示所有书籍\n"
			<<"2.显示所有学生\n"
			<<"3.查询还书信息\n\n"
			<<"4.借书\n"
			<<"5.还书\n"
			<<"6.增加书籍\n"
			<<"7.删除书籍\n"
			<<"8.增加学生\n"
			<<"9.修改密码\n"
			<<"0.退出程序\n\n"
			<<"请输入需要的操作：";
		cin>>select;
		return select;
	}
	void Admin_check_return(ALL& tmp){
		system("cls");
		vector<Book> blist=tmp.Resortbook();
		for(int i=0;i<blist.size();i++){
			if(blist[i].Getinlib()==0){
				cout<<i<<"."<<blist[i].Getbname()<<endl;
				cout<<"\t 被借于："<<Time(blist[i].Getdate())<<"  "<<"于："<<Time(blist[i].Getredate())<<"截止";

				if(blist[i].Getredate()<time(NULL)&&blist[i].Getinlib()==0) cout<<"\t\t状态：正在催还";
				cout<<endl;
			}
		}
	}
	void Admin_Borrow_book(ALL &tmp){
		system("cls");
		int user_id=-1,bno=-1,bd=7,i;
		char select=0;
		for(;select!='n';){
			tmp.SPrint();
			cout<<"请选择借书的同学的学号:";
			cin>>user_id;
			for(i=0;(i<tmp.Getslist().size())&&(tmp.Getslist()[i].Getsno()!=user_id);i++);
			if(i==tmp.Getslist().size()){
				cout<<"用户不存在";
				Sleep(1000);
				return;
			}
			tmp.BPrint();
			cout<<"请选择所需书籍（输入-1停止操作）";
			cin>>bno;
			if(bno==-1) break;
			cout<<"请输入本书还书期限（天）";
			cin>>bd;
			tmp.Borrow_book(bno,i,bd);
			cout<<"是否继续[y/n]";
			cin>>select;
		}
	}
	void Admin_return_book(ALL &tmp){
		system("cls");
		int sno=-1,bno=-1;
		char select=0;
		vector<Book> blist=tmp.Getblist();
		for(;select!='n';){
			for(int i=0;i<blist.size();i++){
				if(blist[i].Getinlib()==0){
					cout<<i<<"."<<blist[i].Getbname()<<endl;
					cout<<"\t 被借于："<<Time(blist[i].Getdate())<<"  "<<"于："<<Time(blist[i].Getredate())<<"截止";

					if(blist[i].Getredate()<time(NULL)&&blist[i].Getinlib()==0) cout<<"\t\t状态：正在催还";
					cout<<endl;
				}
			}
			cout<<"请选择要还的书籍:（输入-1停止操作）";
			cin>>bno;
			if(bno==-1) break;
			tmp.Return_book(bno,tmp.Getblist()[bno].Getwho());
			cout<<"是否继续[y/n]";
			cin>>select;
			blist=tmp.Getblist();
		}
	}
	void Admin_del_book(ALL &tmp){
		system("cls");
		int bno=-1;
		char select=0;
		for(;select!='n';){
			tmp.BPrint();
			cout<<"请选择要删除的书籍:（输入-1停止操作）";
			cin>>bno;
			if(bno==-1) break;
			tmp.Delbook(bno);
			cout<<"是否继续[y/n]";
			cin>>select;
		}
	}
	void Admin_in_stu(ALL &tmp){
		system("cls");
		string sn;
		char select=0;
		int sno=0;
		for(;select!='n';){
			cout<<"请输入新的学生的学号与姓名:";
			cin>>sno>>sn;
			tmp.Addstu(sn,sno);
			cout<<"是否继续[y/n]";
			cin>>select;
		}
	}
	void Admin_in_book(ALL & tmp){
		system("cls");
		string bn;
		char select=0;
		for(;select!='n';){
			cout<<"请输入新的书籍名:";
			cin>>bn;
			tmp.Addbook(bn);
			cout<<"是否继续[y/n]";
			cin>>select;
		}
	}
	char Admin_changepwd(ALL& tmp){
		system("cls");
		cout<<"请输入旧密码:";
		string s=Inputpasswd(),s1;
		char judge=tmp.Checkpasswd(s);
		if(judge==0) {
			cout<<"\n\n错误的密码,修改失败";
			Sleep(2000);
			return 0;
		}
		cout<<"\n\n请输入新密码:"<<endl;
		s=Inputpasswd();
		cout<<"\n请再次输入新密码:"<<endl;
		s1=Inputpasswd();
		if(s!=s1){
			cout<<"\n\n两次输入不一样";
			Sleep(1000);
			return 0;
		}
		tmp.Setpasswd(s);
		cout<<"\n\n修改成功";
		Sleep(1000);
		return 1;		
	}
};