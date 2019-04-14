// Created by me@rochus-keller.ch on 2019-04-10

#include "LlOberon.h"
#include <memory>
using namespace Ll;

static std::auto_ptr<Oberon> s_inst;


Oberon* Oberon::_inst()
{
    if( s_inst.get() == 0 )
        s_inst.reset( new Oberon() );
    return s_inst.get();
}

Oberon::Oberon()
{

}

Oberon::~Oberon()
{
    s_inst.release();
}


void Ll::Oberon::GetSelection(Texts::Text _0, int _1, int _2, int _3)
{
    // NOP
}
