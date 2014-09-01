#include		<iostream>
#include		<string>
#include		<vector>

using namespace std;

class Course
{
		pubilc:
				Course(string n="",char c=0,float g=-1,char p=-1);
				Course(Course & cp):grade(cp.Getgrade),gname(cp.Getname),pass(cp.Getpass),credit(cp.Getcredit){}
				char Insertgrade(float g);
				char Insertgrade(char p) {pass=p};
				float Getgrade() {return grade;}
				string Getname() {return name;}
				char Getpass()	{return pass;}
				char Getcredit() {return credit;}
		private:
				float grade;
				string gname;
				char pass;
				char credit;
};

char	Course::Insertgrade(float g){
					name=n;
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
			Clist(Clist & cp):glist(cp.Getglist),max(cp.Getglist),min(cp.Getglist),gpa(cp.Getglist),countcoures(cp.Getcountcoures){}
		  void Insertcourse(string cname,char c){
				Course tmp(cname,c);
				glist.push_back(tmp);
				countcoures++;
			}
			void Insertgrade(vector<int> g)
			{
				for(int i=0;i<g.size();i++){
					glist[(int)g[i]/101].Insergrade(g[i]%101);
					//将成绩传输时写成 课程号*101+成绩的形式，方便传输
				}
				$this->Refreshgpa();
			}
			void Insertgrade(vector<char> p)
			{
				for(int i=0;i<g.size();i++){
					glist[(int)g[i]/10].Insertgrade(g[i]%10);
				}
			}
			void Refreshgpa();
			vector<Course> Getglist(){return glist;}
			float Getmax{return max;}
		  float Getmin{return min;}
			float Getgpa{return gpa};
		  int		Getcountcoures{return countcoures;}


  private:
			vector<Course> glist;
			float max;
		  float min;
			float gpa;
		  int  countcoures;
};
void Glist::Refreshgpa(){
	int credit=0;
	gpa=0;
	for(int i=0;i<glist.size();i++){
		if(glist[i].Getgrade()==-1) continue;
		gpa+=glist[i].Getgrade()*glist[i].Getcredit();
		credit+=glist[i].Getcredit();
	}
	gpa/=credit;
}


class STU
{
		public:
				STU(int sno=0,string sname="");
				
		private:
				string sname;
				static int sno;
};
