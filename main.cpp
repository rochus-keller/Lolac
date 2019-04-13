// Created by me@rochus-keller.ch on 2019-04-10

#include "LlLSC.h"
#include "LlLSV.h"
#include "LlTexts.h"
#include <iostream>

int main(int argc, char *argv[])
{
    std::cout << "Lolac version 19-04-13/c++" << std::endl
        << "see https://github.com/rochus-keller/Lolac for more information" << std::endl;

    if( argc < 3 )
    {
        std::cout << "usage: Lolac inFilePath outFilePath" << std::endl;
        return 0;
    }

    for( int i = 1; i < argc; i++ )
        Ll::Texts::putArg(argv[i]);

    try
    {
        Ll::LSC::_inst()->Compile();
        Ll::LSV::_inst()->List();
    }catch( const char* str )
    {
        std::cerr << str << std::endl;
    }

    return 0;
}
