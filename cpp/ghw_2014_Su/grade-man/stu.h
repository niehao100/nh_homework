#include		<iostream>
#include		<string>
#include		<stdio.h>
#include		<vector>
#include		<stdlib.h>
#include		"md5.h"
//#include<conin.h>//for windows
using namespace std;

class Course
{
		public:
				Course(string n="",char c=0,double g=-1,char p=-1){
					cname=n;
				  credit=c;
					grade=g;
					pass=p;
				}
				Course(const Course &cp):grade(cp.Getgrade()),cname(cp.Getcname()),pass(cp.Getpass()),credit(cp.Getcredit()){}
				char Insertgrade(double g);
				char Insertgrade(unsigned char p) {grade=-1;pass=p;}
				float Getgrade() const {return grade;}
				string Getcname() const {return cname;}
				char Getpass()	const {return pass;}
				char Getcredit() const {return credit;}
				int Print(){
					cout<<cname<<":\t";
					if(grade!=-1)	cout<<grade;
					if(pass==1) cout<<"\t通过";
					if(pass==2) cout<<"\t良好";
					if(pass==3) cout<<"\t优秀";
					if(pass==0) cout<<"\t不及格";
					if(pass==-1) cout<<"\t无信息";
				}
		private:
				double grade;
				string cname;
				char pass;//1表示通过，2良好，3优秀
				char credit;
};

char	Course::Insertgrade(double g){
					grade=g;
				  if(g>=80){
									if(g>=90) pass=3;
									else pass=2;
				  }
				  else{
								  if(g>=60) pass=1;
							    else pass=0;
						}
				}

class Clist
{
	public:
		  Clist(vector<Course> cl):clist(cl){
				gpa=0;
				min=100;
				max=0;
				countcoures=0;
			}
			Clist(const Clist &cp):clist(cp.Getclist()),max(cp.Getmax()),min(cp.Getmin()),gpa(cp.Getgpa()),countcoures(cp.Getcountcoures()){}
		  void Insertcourse(string cname,char c){
				Course tmp(cname,c,(double)-1,(char)-1);
				clist.push_back(tmp);
				countcoures++;
			}
			void Delcourse(int cno){
				 clist.erase(clist.begin()+cno);  
			}
			void Insertgrade(vector<double> g)
			{
				for(int i=0;i<g.size();i++){
					clist[(int)g[i]/101].Insertgrade(g[i]-(int)g[i]/101);
					if((g[i]-(int)g[i]/101)<min) min=g[i]-(int)g[i]/101;
					else if((g[i]-(int)g[i]/101)>max) max=g[i]-(int)g[i]/101;
					//将成绩传输时写成 课程号*101+成绩的形式，方便传输
				}
				Refreshgpa();
			}
			void Insertgrade(vector<unsigned char> p) 
			{
				for(int i=0;i<p.size();i++){
					clist[(int)p[i]/10].Insertgrade((unsigned char)(p[i]%10));//副作用是只能有25门课程
				}
			}
			void Refreshgpa();
			vector<Course> Getclist() const{return clist;}
			float Getmax() const{return max;}
		  float Getmin() const{return min;}
			float Getgpa() const{return gpa;}
		  int		Getcountcoures() const{return countcoures;}
			int   Getpass();
			void Print();
	protected:
			vector<Course> clist;
			float max;
		  float min;
			float gpa;
		  int  countcoures;
};
void Clist::Refreshgpa(){
	int credit=0;
	gpa=0;
	for(int i=0;i<clist.size();i++){
		if(clist[i].Getgrade()==-1) continue;//-1表示记通过
		gpa+=clist[i].Getgrade()*clist[i].Getcredit();
		credit+=clist[i].Getcredit();
	}
	gpa/=credit;
}
void Clist::Print(){
	for(int i=0;i<clist.size();i++){
		clist[i].Print();
		if((i%3)==2) cout<<endl;
		else cout<"\t";
	}
}

class Password{
	public:
		Password(string s=""):passwd(md5(s)){Try=0;}
		Password(const Password& cp):passwd(cp.passwd){Try=0;}
		void Setpasswd(string s=""){passwd=md5(s);}
		char Checkpasswd(string s=""){
			Try++;
			if(Try<4){
					count++;
					if(passwd==md5(""))
					return 1;
					else if(s==passwd)
					return 1;
					count--;
					return 0;
			}
			else {
				Try=0;
				exit(0);
			}
		}
	private:
		string passwd;
		int Try;//限制尝试次数
		int count;//统计登陆次数
};

class STU:public Clist,public Password{
	public:
		STU(string s,vector<Course>& cp,int sn):sname(s),Clist(cp),Password(),sno(sn){}
		STU(const STU& cp):sname(cp.Getsname()),Clist(cp),Password(cp),sno(cp.sno){}
		string Getsname() const {return sname;}
		bool operator<(const STU& tmp){return (gpa<tmp.gpa);}	
		int Getsno(){return sno;}
		void Getpass(int* tmp);//该数组第一个值是挂科数，第二个是挂科学分
		int Getpass();
		int Getcredit_sum();
		void SPrint(){cout<<sname<<"\tGPA:"<<gpa<<endl;
			Print();
		}
	private:
		string sname;
		string depart;
		int sno;
};
void STU::Getpass(int* tmp){
  for(int i=0;i<clist.size();i++){
		if(clist[i].Getpass()==0){
			tmp[0]++;
			tmp[1]+=clist[i].Getcredit();
		}
	}
}
int STU::Getpass()
{
	int tmp;
		for(int i=0;i<clist.size();i++){
		if(clist[i].Getpass()==0){
			tmp++;
		}
		}
		return tmp;
}

int STU::Getcredit_sum(){
	int sum=0;
  for(int i=0;i<clist.size();i++) sum+=clist[i].Getcredit();
		return sum;
}

class ALL:public Password{
  public:
		ALL(){}
		ALL(const ALL& cp):Password(cp),slist(cp.slist){}
    double Getavegpa();
		vector<double> Getave_per_course();
		vector<STU> Resort();
		int Countpass();
		vector<STU>  Getslist() const { return slist;} 
		void Print();
		void Insertstu(string& name,vector<Course> cl){
			STU tmp(name,cl,slist.size()+1);
			slist.push_back(tmp);
		}
		void Insertgrade(int sno,vector<unsigned char> tmp){
			slist[sno].Insertgrade(tmp);
		}
		void Insertgrade(int sno,vector<double> tmp){
			slist[sno].Insertgrade(tmp);
		}
		void Delcourse(int sno,int cno){
			slist[sno].Delcourse(cno);
		}
		void Insertcourse(int sno,string cn,char c){
			slist[sno].Insertcourse(cn,c);
		}
	private:
		vector<STU> slist;
};
double ALL::Getavegpa(){
	double sum=0;
  for(int i=0;i<slist.size();i++)
	 sum+=slist[i].Getgpa();
  return sum/slist.size();
}
vector<double> ALL::Getave_per_course(){
	double sum=0;
	vector<double> c;
	for(int j=0;j<(slist[0].Getclist()).size();j++){
		if((slist[0].Getclist())[j].Getgrade()==-1) continue;
		for(int i=0;i<slist.size();i++){
			sum+=(slist[i].Getclist())[j].Getgrade();
		}
		c.push_back(sum/slist.size());
		sum=0;
	}
	return c;
}
vector<STU> ALL::Resort(){
	vector<STU> tslist=slist;
  for(int i=1;i<tslist.size();i++){
		for(int j=0;j<(tslist.size()-i);i++){
			if(tslist[j]<tslist[j+1])		swap(tslist[j],tslist[j+1]);
		}
	}
	return tslist;
}
int ALL::Countpass(){
	int count;
	for(int i=1;i<slist.size();i++) count+=slist[1].Getpass();
  return count;
}
void ALL::Print(){
	for(int i=0;i<slist.size();i++){
		slist[i].SPrint();
		cout<<endl;
	}
}




class Views{
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
		system("clear");
		cout<<"**************************************************"
				<<"\n\n\t\t\t\t请输入学号:";//管理员帐号编码0
		cin>>name;
		return name;
		}

	//学生用户登录后的行为	
	char Index(){
		int select=42;
		system("clear");
		//for win system("cls");	
	cout<<"________________________________________________________\n\n"
		  <<"\t\t欢迎使用学生信息管理系统\n\n"
			<<"________________________________________________________\n\n\n\n"
			<<"1.查询本人GPA\n\n"
			<<"2.查询各科成绩\n\n"
			<<"3.查询本人GPA排名\n\n"
			<<"4.查询本人挂科情况\n\n"
			<<"5.注销\n\n"
			<<"6.退出\n\n\n\n"
			<<"请输入需要的操作：";
  cin>>select;
	return select;
	}	
	void Stu_showgpa(int sno,vector<STU> tmp){
		system("clear");
		cout<<tmp[sno-1].Getsname()<<"同学,\n你的GPA为"<<tmp[sno-1].Getgpa();
		char t;
		cout<<"\n\n\n\n\n\n\n\n\t\t\t输入任意键返回";
		cin>>t;
	}
	void Stu_showgrade(int sno,vector<STU> tmp){
		system("clear");
		  tmp[sno-1].SPrint();
		char t;
		cout<<"\n\n\n\n\n\n\n\n\t\t\t输入任意键返回";
		cin>>t;
	}
	void Stu_showrank(int sno,ALL& tmp){
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
	void Stu_showpass(int sno,vector<STU> tmp){
		system("clear");
		int t[2]={0,0};
		tmp[sno-1].Getpass(t);
		if(t[0]!=0) cout<<tmp[sno-1].Getsname()<<"\n\n\n\n同学，你的挂科数为:"<<t[0]<<"\t挂科学分为:"<<t[1]<<endl;
		char s;
		cout<<"\n\n\n\n\n\n\n\n\t\t\t输入任意键返回";
		cin>>s;
	}
	


		//管理员用户登录后的行为
	char Admin(){
		int select=42;
		system("clear");
		//for win system("cls");	
	cout<<"________________________________________________________\n"
		  <<"\t\t欢迎使用学生信息管理系统\n"
			<<"________________________________________________________\n\n"
			<<"\t\t\t\t查询\n\n\n"
			<<"1.显示成绩排名\n"
			<<"2.查询平均GPA\n"
			<<"3.显示所有课程\n"
			<<"4.显示所有学生\n"
			<<"5.查询某学生信息\n\n"
			<<"\t\t修改\n\n"
			<<"6.录入成绩\n"
			<<"7.修改课程信息\n"
			<<"8.修改学生信息\n"
			<<"0.退出程序\n\n"
			<<"请输入需要的操作：";
  cin>>select;
	return select;
	}
	void Admin_showrank(ALL& tmp){
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
	void Admin_showavegpa(ALL& tmp){
		system("clear");
		cout<<"平均GPA为:"<<tmp.Getavegpa();
		char t;
		cout<<"\n\n\n\n\n\n\n\n\t\t\t输入任意键返回";
		cin>>t;
	}
	void Admin_show_all_course(vector<Course> tmp){
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
	void Admin_show_all_stu(vector<STU> tmp){
		system("clear");
		for(int i=0;i<tmp.size();i++){
			cout<<tmp[i].Getsname();
			if(i%5==4) cout<<endl;
			else cout<<"\t";
		}
		char t;
		cout<<"\n\n\n\n\n\n\n\n\t\t\t输入任意键返回";
		cin>>t;
	}
  void Admin_in_grade(ALL & tmp);
	void Admin_in_stu(ALL &tmp){
		system("clear");
		string sn;
		char select;
		for(;select!='n';){
		cout<<"请输入新的学生姓名:";
		cin>>sn;
		cout<<"test";
		tmp.Insertstu(sn,(tmp.Getslist())[0].Getclist());
		cout<<"是否继续[y/n]";
		cin>>select;
		}
  }
	void Admin_in_course(ALL & tmp);
 };
 void Views::Admin_in_grade(ALL & tmp){
				Admin_show_all_course(tmp.Getslist()[0].Getclist());
				char select1=42,select2=42;
				cout<<"请选择要录入的课程:"<<endl;
				cin>>select1;
				cout<<"该课程是否为记通过？[y/n]";
				cin>>select2;
				if(select2=='y'){
					vector<unsigned char> grade;
					unsigned char g=0;
					for(int i=0;i<tmp.Getslist().size();i++){
						cout<<tmp.Getslist()[i].Getsno()<<"."<<tmp.Getslist()[i].Getsname()<<":[不及格/及格/良好/优秀]0/1/2/3";
						cin>>g;
						if(g==1||g==2||g==3||g==0){
						grade.push_back(10*select1+g);
						tmp.Insertgrade(i,grade);
						grade.pop_back();
						}
						else{
							cout<<"错误的输入"<<endl;
							i--;
						}
					}
				
				}
				else{
				  vector<double> grade;
					double g=0;
					for(int i=0;i<tmp.Getslist().size();i++){
						cout<<tmp.Getslist()[i].Getsno()<<"."<<tmp.Getslist()[i].Getsname()<<":";
						cin>>g;
						if(g>=0&&g<=100){
						grade.push_back(select1*101+g);
						tmp.Insertgrade(i,grade);
						grade.pop_back();
						}
						else{
							cout<<"错误的输入"<<endl;
							i--;
						}
					}
				}
 }
	void Views::Admin_in_course(ALL & tmp){
		system("clear");
		char select,select2='y';
		cout<<"1.增加课程"
			<<"\n\n2.删除课程"
			<<"\n\n请输入需要的操作:";
		cin>>select;
		if(select==1){
			system("clear");
			string cn;
			char c;
			for(;select2=='y';){
			cout<<"请输入课程名与学分：";
		  cin>>cn>>c;
			for(int i=1;i<tmp.Getslist().size();i++){
				tmp.Insertcourse(i,cn,c);
			}
			cout<<"\n是否继续:[y/n]";
			cin>>select2;
			}
		}
		if(select==2){
		Admin_show_all_course(tmp.Getslist()[0].Getclist());
		for(;select2=='y';){
		cout<<"\n请选择需要删除的课程:";
		int cno=0;
		cin>>cno;
		for(int i=0;i<tmp.Getslist().size();i++){
			tmp.Delcourse(i,cno-1);
			}
		cout<<"\n是否继续:[y/n]";
		cin>>select2;
			}
		}
	}


