// 测试文件模板
#include <iostream>
#include <sstream>
#include <fstream>
#include "QM2013011280.hpp"
#include <vector>
#include <list>

class Test2013011280
{
public:
	static void Test()
	{
		unsigned int total_score = 0;
		std::ifstream test_data_file("BaoShurui.txt");
		
		std::string minimum_items, nonused_items, result_items, score_string, rubish;
		std::list<std::string> result_string_list;
		std::list<bool> tested_result_list;
		std::list<unsigned int> tested_index_list;
		unsigned int current_test_index = -1;
		while (std::getline(test_data_file, minimum_items) && std::getline(test_data_file, nonused_items) && 
			std::getline(test_data_file, result_items) && std::getline(test_data_file, score_string))// 如果没有可读的，就退出
		{
			std::getline(test_data_file, rubish);
			current_test_index++;
			std::cout<<"Current Index: "<<current_test_index<<std::endl;

			std::stringstream score_stream(score_string);
			unsigned int score_int;
			score_stream>>score_int;
			if (score_int == 0)
				continue;

			unsigned int item;
			std::string result_item;
			// 读取最小项
			std::stringstream minimum_stream(minimum_items);
			std::vector<unsigned int> minimum_array;
			while (minimum_stream>>item)
				minimum_array.push_back(item);

			// 读取读取无关项
			std::stringstream nonused_stream(nonused_items);
			std::vector<unsigned int> nonused_array;
			while (nonused_stream>>item)
				nonused_array.push_back(item);
			
			// 读取结果
			std::stringstream result_stream(result_items);
			std::vector<std::string> result_array;
			while (result_stream>>result_item)
				result_array.push_back(result_item);

			// 调用测试
			
			std::string tested_result;
			try
			{
				tested_result = QM2013011280::QM(minimum_array.data(), minimum_array.size(), nonused_array.data(), 
					nonused_array.size());
				result_string_list.push_back(tested_result);
			}
			catch (...)
			{
				continue;
			}

			// 检查测试
			bool is_passed = false;
			for (auto i = result_array.cbegin(); i != result_array.cend(); i++)
			{
				if (CheckEqual(*i, tested_result))
				{
					is_passed = true;
					break;
				}
			}
			tested_result_list.push_back(is_passed);
			tested_index_list.push_back(current_test_index);

			if (is_passed)
				total_score += score_int;

		}

		std::stringstream score_stream;
		score_stream<<total_score;
		//有的学生Name()和StudentID()结尾有\n
		std::string student_id = *QM2013011280::StudentID().rbegin() == '\n' ? QM2013011280::StudentID().substr(0, QM2013011280::StudentID().size() - 1) : 
			QM2013011280::StudentID();
		std::string name = *QM2013011280::Name().rbegin() == '\n' ? QM2013011280::Name().substr(0, QM2013011280::Name().size() - 1) : 
			QM2013011280::Name();
		std::string file_name = "Result/Result_" + student_id + "_" + name + "_" + score_stream.str() + ".txt";
		std::ofstream result_file(file_name);
		if(result_file)
		{
			auto i = result_string_list.cbegin();
			auto j = tested_result_list.cbegin();
			auto k = tested_index_list.cbegin();
			for (; i != result_string_list.cend(); i++, j++, k++)
				result_file<<*k<<'\t'<<*i<<'\t'<<*j<<std::endl;
		}

		test_data_file.close();
		result_file.close();
	}

	static bool CheckEqual(const std::string &a, const std::string &b)
	{
		std::list<std::string> a_splitted, b_splitted;
		a_splitted = Split(a);
		b_splitted = Split(b);
		if (a_splitted.size() != b_splitted.size())
			return false;
		for (auto i = a_splitted.cbegin(); i != a_splitted.cend(); i++)
		{
			bool equal_found = false;
			for (auto j = b_splitted.cbegin(); j != b_splitted.cend(); j++)
			{
				if (*i == *j)
				{
					equal_found = true;
					break;
				}
			}
			if (!equal_found)
				return false;
		}
		return true;
	}

	static std::list<std::string> Split(const std::string &str) 
	{
		std::string temp;
		std::list<std::string> retval;
		int current_index = 0;
		int index = 0;
		while ((index = str.find_first_of('+', current_index)) != -1)
		{
			temp = str.substr(current_index, index - current_index);
			retval.push_back(temp);
			current_index = index + 1;
		}

		retval.push_back(str.substr(current_index));
		return retval;
	}
};