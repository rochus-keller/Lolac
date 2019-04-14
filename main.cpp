// Created by me@rochus-keller.ch on 2019-04-10

#include "LlLSC.h"
#include "LlLSV.h"
#include "LlTexts.h"
#include <iostream>

int main(int argc, const char *argv[])
{
    std::cout << "Lolac version 19-04-14/c++" << std::endl
        << "see https://github.com/rochus-keller/Lolac for more information" << std::endl;

    if( argc < 3 )
    {
        std::cout << "usage: Lolac inFilePath outFilePath" << std::endl;
        return 0;
    }

    try
    {
        Ll::LSC::_inst()->Compile(argv[1]);
        Ll::LSV::_inst()->List(argv[2]);
        Ll::_Root::deleteArena();
    }catch( const char* str )
    {
        std::cerr << str << std::endl;
        return -1;
    }catch( ... )
    {
        std::cerr << "unknown exception" << std::endl;
        return -1;
    }

    return 0;
}
