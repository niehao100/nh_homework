#include		<iostream>
#include		<string>
#include		<vector>
#include		<stdlib.h>
#include		"md5.h"

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
				Course(const Course &cp):grade(cp.Getgrade()),cname(cp.Getname()),pass(cp.Getpass()),credit(cp.Getcredit()){}
				char Insertgrade(double g);
				char Insertgrade(unsigned char p) {grade=-1;pass=p;}
				float Getgrade() const {return grade;}
				string Getname() const {return cname;}
				char Getpass()	const {return pass;}
				char Getcredit() const {return credit;}
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
		  Clist(){
				gpa=0;
				min=0;
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
				 clist.erase(clist.begin()+cno-1);  
			}
			void Insertgrade(vector<double> g)
			{
				for(int i=0;i<g.size();i++){
					clist[(int)g[i]/101].Insertgrade(g[i]-(int)g[i]/101);
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

class Password{
	public:
		Password(string s=""):passwd(md5(s)){try=0;}
		Password(const Password& cp):passwd(cp.passwd){try=0;}
		void Setpasswd(string s=""){passwd=md5(s);}
		char Checkpasswd(string s=""){
			try++;
			if(try<4){
					count++;
					if(passwd==md5(""))
					return 1;
					else if(md5(s)==passwd)
					return 1;
					count--;
					return 0;
			}
			else exit(0);
		}
	private:
		string passwd;
		int try;//限制尝试次数
		int count;//统计登陆次数
};

class STU:public Clist,public Password{
	public:
		STU(string s,const Clist& cp):sname(s),Clist(cp),Password(){}
		STU(const STU& cp):sname(cp.Getsname()),Clist(cp),Password(cp){}
		string Getsname() const {return sname;}
	private:
		string sname;
		string depart;
};

class ALL:public Password{
	public:
  private:
		vector<STU> slist;
};
