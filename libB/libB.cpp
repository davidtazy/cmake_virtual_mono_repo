#include <iostream>
#include "libB.h"
namespace libB{
		
		void LibB::do_this()const{
            std::cout<<__PRETTY_FUNCTION__<<std::endl;
		}
}
