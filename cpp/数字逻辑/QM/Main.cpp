#include <iostream>
#include "QMTemplate.hpp"
#include <cassert>
void main()
{
	std::cout<<QM2013011280::Name()<<std::endl;	
	std::cout<<QM2013011280::StudentID()<<std::endl;	

    const unsigned int m_count = 6;
    const unsigned int d_count = 2;
    const unsigned int m[m_count] = {4, 8, 10, 11, 12, 15};
    const unsigned int d[d_count] = {9, 14}; 

    std::string retval = QM2013011280::QM(m, m_count, d, d_count);
	
	assert(retval == "BC'D'+AC+AB'" || retval == "BC'D'+AC+AD'");
}
