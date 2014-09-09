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
				string Getcname() const {return cname;}
				char Getpass()	const {return pass;}
				char Getcredit() const {return credit;}
				int Print(){
					cout<<cname<<":\t"0
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
		  Clist(){
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
				 clist.erase(clist.begin()+cno-1);  
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
					else if(md5(s)==passwd)
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
		STU(string s,const Clist& cp,int sn):sname(s),Clist(cp),Password(),sno(sn){}
		STU(const STU& cp):sname(cp.Getsname()),Clist(cp),Password(cp),sno(cp.sno){}
		string Getsname() const {return sname;}
		bool operator<(const STU& tmp){return (gpa<tmp.gpa);}	
		int Getsno(){return sno;}
		int* Getpass();//该数组第一个值是挂科数，第二个是挂科学分
		int Getcredit_sum();
		void SPrint(){cout<<sname<<"\tGPA:"<<gpa<<endl;
			Print();
		}
	private:
		string sname;
		string depart;
		int sno;
};
int* STU::Getpass(){
	int c[2]={0,0};
  for(int i=0;i<clist.size();i++){
		if(clist[i].Getpass()==0){
			c[0]++;
			c[1]+=clist[i].Getcredit();
		}
	}
		return c;
}
int STU::Getcredit_sum(){
	int sum=0;
  for(int i=0;i<clist.size();i++) sum+=clist[i].Getcredit();
		return sum;
}

class ALL:public Password{
  public:
		ALL(const ALL& cp):Password(cp),slist(cp.slist){}
    double Getavegpa();
		vector<double> Getave_per_course();
		void Resort();
		int Countpass();
		vector<STU>  Getslist() const { return slist;} 
		void Print();
		void Insertstu(string name,Clist cl){
			STU tmp(name,cl,slist.size()+1);
			slist.push_back(tmp);
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
	for(int i=1;i<slist.size();i++) count+=slist[1].Getpass()[0];
  return count;
}
void ALL::Print(){
	for(int i=0;i<slist,size();i++){
		slist[i].SPrint();
		cout<<endl;
	}
}

