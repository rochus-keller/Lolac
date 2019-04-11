// Created by me@rochus-keller.ch on 2019-04-10

#include "LlTexts.h"
#include <memory>
#include <fstream>
#include <iostream>
#include <vector>
using namespace Ll;

static std::auto_ptr<Texts> s_inst;

static std::vector<std::string> s_args;

Texts* Texts::_inst()
{
    if( s_inst.get() == 0 )
        s_inst.reset( new Texts() );
    return s_inst.get();
}

Texts::Texts():Char(1),Name(2),String(3)
{

}

void Ll::Texts::OpenWriter(Ll::Texts::Writer& _0)
{
    _0.buf.clear();
}

int Ll::Texts::Pos(const Ll::Texts::Reader& _0)
{
    return _0.d_off;
}

void Ll::Texts::WriteString(Ll::Texts::Writer& _0, _ValArray<char> _1)
{
    _0.buf << _1.data();
}

void Ll::Texts::WriteInt( Ll::Texts::Writer& _0, int _1, int _2)
{
    _0.buf << _1;
}

void Ll::Texts::WriteLn( Ll::Texts::Writer& _0)
{
    _0.buf << "\n";
}

void Ll::Texts::Append(int _0, std::stringstream& _1)
{
    _1.flush();
    std::cout << _1.str();
    _1.str(std::string());
}

void Ll::Texts::Read(Ll::Texts::Reader& _0, char& _1)
{
    if( !_0.eot )
    {
        _1 = _0.d_txt->d_str[ _0.d_off++ ];
        _0.eot = _0.d_off >= _0.d_txt->d_str.size();
    }
}

void Ll::Texts::OpenReader(Ll::Texts::Reader& r, Ll::Texts::Text t, int off)
{
    r.d_txt = t;
    r.d_off = off;
    r.eot = r.d_off >= t->d_str.size();
}

void Ll::Texts::Write(Ll::Texts::Writer& _0, _ValArray<char> _1)
{
    _0.buf << _1.data();
}

void Ll::Texts::OpenScanner(const Ll::Texts::Scanner& _0, int _1, int _2)
{
    // NOP
}

void Ll::Texts::Scan(Ll::Texts::Scanner& _0)
{
    static int next = 0;
    if( next < s_args.size() )
    {
        _0.c = 0;
        _0.class_ = 2; // Name
        _0.s = s_args[next++].c_str();
    }else
    {
        _0.c = 0;
        _0.class_ = 0;
        _0.s.clear();
    }
}

void Ll::Texts::Open(Ll::Texts::Text text, _ValArray<char> path)
{
    std::ifstream f(path.data());
    if( f.is_open() )
    {
        f.seekg(0, std::ios::end);
        text->d_str.reserve(f.tellg());
        f.seekg(0, std::ios::beg);
        text->d_str.assign((std::istreambuf_iterator<char>(f)),
                    std::istreambuf_iterator<char>());
        f.close();
    }else
        std::cerr << "cannot open file for reading: " << path.data();
}

void Texts::putArg(const char* arg)
{
    s_args.push_back(arg);
}


