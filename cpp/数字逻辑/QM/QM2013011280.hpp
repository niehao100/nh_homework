// 使用自己的“学号”替换所有的2013011280
// 使用自己的“姓名”替换“张三”
//
// QMTemplate.hpp的使用：
// 直接把QMTemplate.hpp当做普通头文件来使用就可以了。实际上hpp就是.cpp和.h的合并。
#ifndef _QM2013011280_HPP_
#define _QM2013011280_HPP_
#define INF 0xffffffffffffffff;
#include <string>
#include <vector>
#include <iostream>
#include<algorithm>
using std::vector;
using std::string;
using std::sort;
using std::unique;
using std::find;
using std::count;

class QM2013011280
{
public:
	static string Name()	{
		// 返回自己的姓名
		return "聂浩";
	}

	static string StudentID(){
		// 返回自己的学号
		return "2013011280";
	}

	static string QM(const unsigned int* m, unsigned int m_count, 
		const unsigned int* d, unsigned int d_count) {
			string retval,tstring;
			vector<vector<unsigned char>> bit,prime_implicant,
				essential_prime_implicant,size2,size4,size8,size16;//存储二进制化的数,素蕴涵项，本质本源蕴涵项,最多八个变量，所以到size8即可
			vector<unsigned char> cover,choose;//choose选择怎么选择d的项
			int i=0,j=0,is_d=0;//循环用变量

			//确定变量数
			if(!m_count) return "0";
			QM2013011280::FindHighbit(m[m_count-1]);
			if(d_count)
				QM2013011280::FindHighbit(d[d_count-1]);
			//二进制化，vector的最后一个数存储二进制的0的个数
			for(is_d=0;is_d<(1<<d_count);is_d++){
				essential_prime_implicant.clear();
				prime_implicant.clear();
				size2.clear();
				size4.clear();
				size8.clear();
				size16.clear();
				bit.clear();
				for(i=0;i<m_count;i++){
					bit.push_back(Rebit(m[i],flag_max));
					cover.push_back(m[i]);
				}
				choose=Rebit(is_d,d_count);
				for(i=0;i<d_count;i++){
					if(choose[i]){
						bit.push_back(Rebit(d[i],flag_max));
						cover.push_back(d[i]);
					}
				}

				search_prime_implicant(bit,size2,prime_implicant);
				sort(size2.begin(),size2.end(),compare);
				size2.erase(unique(size2.begin(),size2.end()),size2.end());

				search_prime_implicant(size2,size4,prime_implicant);
				sort(size4.begin(),size4.end(),compare);
				size4.erase(unique(size4.begin(),size4.end()),size4.end());

				search_prime_implicant(size4,size8,prime_implicant);
				sort(size8.begin(),size8.end(),compare);
				size8.erase(unique(size8.begin(),size8.end()),size8.end());

				search_prime_implicant(size8,size16,prime_implicant);
				sort(size16.begin(),size16.end(),compare);
				size16.erase(unique(size16.begin(),size16.end()),size16.end());

				sort(prime_implicant.begin(),prime_implicant.end(),compare);

				prime_implicant.erase(unique(prime_implicant.begin(),prime_implicant.end()),prime_implicant.end());
				//覆盖求本质本源蕴含
				int tmp=0,is_epi=0;
				for(;!cover.empty();){
					for(i=0;i<cover.size()&&(!cover.empty());i++){
						for(j=0;j<prime_implicant.size()&&(!cover.empty());j++){
							if(prime_implicant[j].end()
								!=find((prime_implicant[j]).begin()+flag_max+1,
								(prime_implicant[j]).end(),cover[i])){
									tmp=j;
									is_epi++;
							}
						}
						if(is_epi==1){
							i=-1;
							cover_one(prime_implicant,essential_prime_implicant,cover,tmp);
						}
						is_epi=0;

					}
					sort(prime_implicant.begin(),prime_implicant.end(),compare);
					for(j=0;j<prime_implicant.size()&&(!cover.empty());j++){
						if(prime_implicant[j].end()
							!=find((prime_implicant[j]).begin()+flag_max+1,
							(prime_implicant[j]).end(),cover[0])){
								cover_one(prime_implicant,essential_prime_implicant,cover,j);	
						}
					}
				}
				sort(essential_prime_implicant.begin(),essential_prime_implicant.end(),compare);
				for(i=essential_prime_implicant.end()-essential_prime_implicant.begin()-1;
					i>-1;i--){
						char a='A';
						for(j=0;j<flag_max;j++,a++){						
							switch(essential_prime_implicant[i][j]){
							case 1:tstring+=a;break;
							case 0:tstring+=a;tstring+="'";break;
							default:break;
							}
						}
						if(i&&!tstring.empty()) tstring+="+";
				}
				if(tstring.empty()) tstring='1';
				if(is_d==0) retval=tstring;
				if(count(tstring.begin(),tstring.end(),'+')<count(retval.begin(),retval.end(),'+')) retval=tstring;
				if(count(tstring.begin(),tstring.end(),'+')==count(retval.begin(),retval.end(),'+'))
					if(count_a(tstring)<count_a(retval)) retval=tstring;
				if(tstring=="1") retval=tstring;
				tstring.clear();
			}
			flag_max=0;
			return retval;
	}
	static int FindHighbit(const unsigned int m){
		int flag=0,i=31;
		unsigned tmp = 1<<31;
		for(;i>-1;i--){
			tmp=1<<i;
			if((m&tmp)!=0) {
				flag=i+1;
				break;
			}
		}
		if(flag>flag_max)  flag_max=flag;
		return flag;
	}
	static vector<unsigned char> Rebit(const unsigned int m,const int flag_M){
		unsigned int tmp = 0;
		int i=0,flag=0,count1=0;
		vector<unsigned char> bit;
		for(i=flag_M-1;i>-1;i--){
			tmp=1<<i;
			bit.push_back((m&tmp)!=0);
			if((m&tmp)==0) 
				count1++;
		}
		bit.push_back(count1);
		bit.push_back(m);
		return bit;
	}
	static vector<unsigned char> merge
		(vector<vector<unsigned char>>& bit,int bit1,int bit2){
			int count_diff=0,diff=0,i=0;
			vector<unsigned char> tmp;
			for(i=0;i<flag_max;i++){
				if(bit[bit1][i]==bit[bit2][i]){
					count_diff++;
				}
				else diff=i;
			}
			if(count_diff==(flag_max-1)){
				tmp=bit[bit1];
				if(tmp[diff]==0) 
					tmp[flag_max]-=1;
				tmp[diff]=5;
				for(i=flag_max+1;bit[bit2].begin()+i<bit[bit2].end();i++)
					tmp.push_back(bit[bit2][i]);
				sort(tmp.begin()+flag_max+1,tmp.end());
				tmp.erase(unique(tmp.begin()+flag_max+1,tmp.end()),tmp.end());
			}
			return tmp;
	}
	static void search_prime_implicant
		(vector<vector<unsigned char>>&bit,vector<vector<unsigned char>>& size,
		vector<vector<unsigned char>>&prime_implicant){//搜索素蕴涵项（一级）
			vector<unsigned char> tmp;
			int is_epi,i=0,j=0;
			if(bit.size()==1) {
				prime_implicant.push_back(bit[0]);
				return;
			}
			for(i=0,is_epi=1;i<(bit.size());i++){
				for(j=0;j<bit.size();j++){
					tmp=merge(bit,i,j);
					if(!tmp.empty())	{
						is_epi=0;
						if(j>i)
							size.push_back(tmp);
					}
				}
				if(is_epi==1) 
					prime_implicant.push_back(bit[i]);
				is_epi=1;
			}	
	}	

	static void cover_one(vector<vector<unsigned char>>& prime_implicant,
		vector<vector<unsigned char>>& essential,
		vector<unsigned char>&cover,int count){
			vector<unsigned char> tmp=prime_implicant[count];
			
			essential.push_back(prime_implicant[count]);
			prime_implicant.erase(prime_implicant.begin()+count);
			for(int i=flag_max+1;i<(tmp).size()&&(!cover.empty());i++){
				if(find(cover.begin(),cover.end(),tmp[i])!=cover.end())
					cover.erase(find(cover.begin(),cover.end(),tmp[i]));
				for(int j=0;j<prime_implicant.size();j++){
					if(prime_implicant[j].end()!=find(prime_implicant[j].begin()+flag_max+1,prime_implicant[j].end(),tmp[i]))
						prime_implicant[j].erase(find(prime_implicant[j].begin()+flag_max+1,prime_implicant[j].end(),tmp[i]));
				}
			}
	}
	static int count_a(string s){
		int count=0;
		for(int i=0;i<s.size();i++){
			if(s[i]>='A'&&s[i]<'Z') 
				count++;
		}
		return count;
	}
	static bool compare (vector<unsigned char> a,vector<unsigned char> b){
		if( count(a.begin(),a.begin()+QM2013011280::flag_max-1,5)
			==count(b.begin(),b.begin()+QM2013011280::flag_max-1,5))
			return a.size()>b.size();
		return count(a.begin(),a.begin()+QM2013011280::flag_max,5)
		>count(b.begin(),b.begin()+QM2013011280::flag_max,5);
	}
	static int flag_max;
};

bool operator== (vector<unsigned char> a,vector<unsigned char> b){
	int count_diff=0,diff=0,i=0;
	vector<unsigned char> tmp;
	for(i=0;i<QM2013011280::flag_max;i++){
		if(a[i]==b[i]){
			count_diff++;
		}
	}
	return count_diff==QM2013011280::flag_max;
}
int QM2013011280::flag_max=0;

#endif
