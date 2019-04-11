// Created by me@rochus-keller.ch on 2019-04-10

#include "LlFiles.h"
#include <memory>
using namespace Ll;

static std::auto_ptr<Files> s_inst;


Files* Files::_inst()
{
    if( s_inst.get() == 0 )
        s_inst.reset( new Files() );
    return s_inst.get();
}

Files::Files()
{

}

Files::~Files()
{

}

void Ll::Files::Write(Ll::Files::Rider _0, char _1)
{
    _0.d_file->d_file << _1;
    _0.d_file->d_file.flush();
}

Ll::Files::File Ll::Files::New(_FxArray<char, 128> _0)
{
    FileDesc* res = new FileDesc();
    res->d_file.open(_0.data(), std::ios::out);
    return res;
}

void Ll::Files::Set(Rider& _0, Ll::Files::File _1, int _2)
{
    _0.d_file = _1;
}

void Ll::Files::Register(Ll::Files::File _0)
{
    // NOP
}
