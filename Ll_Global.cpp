#include "Ll_Global.h"
#include <list>
using namespace Ll;

static std::list<_Root*> s_objs;


void*_Root::operator new(size_t n)
{
    void *p = ::operator new(n);
    s_objs.push_back((_Root*)p);
    return p;
}

void _Root::deleteArena()
{
    std::list<_Root*>::iterator i;
    for( i = s_objs.begin(); i != s_objs.end(); ++i )
    {
        delete (*i);
    }
    s_objs.clear();
}

