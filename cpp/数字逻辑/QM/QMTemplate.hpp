// 使用自己的“学号”替换所有的2013011280
// 使用自己的“姓名”替换“张三”
//
// QMTemplate.hpp的使用：
// 直接把QMTemplate.hpp当做普通头文件来使用就可以了。实际上hpp就是.cpp和.h的合并。
#ifndef _QM2013011280_HPP_
#define _QM2013011280_HPP_
#define INF=0xffffffffffffffff;
#include <string>
#include <vector>
class QM201301180
{
public:
	static std::string Name()
	{
		// 返回自己的姓名
		return "聂浩";
	}

	static std::string StudentID()
	{
		// 返回自己的学号
		return "201301180";
	}

	// QM函数
	// 输入：
	// 	最小项数组m, m_count
	// 	无关项数组d, d_count
	// 返回：
	// 	最简表达式
	//  输出中，本质本原蕴含项在前，其他在后。这两部分中的项各自按照变量个数从高到低排列。每一项中高
    //  位比特在前，地位比特在后。高低位比特依次有ABC……代替
	static std::string QM(const unsigned int* m, unsigned int m_count, 
			const unsigned int* d, unsigned int d_count) 
	{
		std::string retval;
		std::vector<unsigned char> *bit=new std::vector<unsigned char>(m_count);
		int tmp=0,i=0,j=0;
		QM201301180::flag_max=0;
		QM201301180::FindHighbit(bit[0],m[m_count-1]);
		QM201301180::FindHighbit(bit[0],d[d_count-1]);
		//
		//
		// 填入你自己的算法
		//
        //
		return retval;
	}

	static std::vector<int> FindHighbit(std::vector<unsigned char> &bit, const unsigned int m){
		int tmp = 0x8000000000000000,flag=0;
		for(;tmp!=0;tmp=(int)(tmp/2)){
			if((m&tmp)!=0) 
				flag++;
			if(flag!=1)
				bit.push_back((m&tmp)!=0);
		}
		if(flag>QM201301180::flag_max) flag==flag_max;
	}

	static std::vector<int> Rebit(std::vector<unsigned char> &bit, const unsigned int m){
		int tmp = 0,i=0;
		for(i=flag_max;i>-1;tmp=1<<i)
			bit.push_back((m&tmp)!=0);
	}
	// 自己添加的成员函数必须是static，这样才可以很好地配合QM函数工作。
	static int flag_max;
};

#endif
