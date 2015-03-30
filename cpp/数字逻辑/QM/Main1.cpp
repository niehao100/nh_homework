#include <iostream>
#include "QM2013011280.hpp"
#include <cassert>
void main()
{
	std::cout<<QM2013011280::Name()<<std::endl;	
	std::cout<<QM2013011280::StudentID()<<std::endl;	

    const unsigned int m_count = 4;
    const unsigned int d_count = 1;
    const unsigned int m[m_count] = {0,1,2,5};
    const unsigned int d[d_count] = {7}; 

    std::string retval = QM2013011280::QM(m, m_count, d, d_count);
	
	assert(retval == "BC'D'+AC+AB'" || retval == "BC'D'+AC+AD'");
}
