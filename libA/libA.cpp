#include <iostream>
#include <libB.h>
#include "libA.h"
namespace libA{		
		void LibA::do_this()const{
            std::cout<<__PRETTY_FUNCTION__<<std::endl;
            libB::LibB b;
            b.do_this();
		}

}
