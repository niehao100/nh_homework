// 使用自己的“学号”替换所有的2013011280
// 使用自己的“姓名”替换“张三”
//
// QMTemplate.hpp的使用：
// 直接把QMTemplate.hpp当做普通头文件来使用就可以了。实际上hpp就是.cpp和.h的合并。
#ifndef _QM2013011280_HPP_
#define _QM2013011280_HPP_

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
		std::int tmp=0,i=0,j=0;
		
		//
		//
		// 填入你自己的算法
		//
        //
		return retval;
	}

	// 自己添加的成员函数必须是static，这样才可以很好地配合QM函数工作。

};

#endif
