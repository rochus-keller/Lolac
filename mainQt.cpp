/*
* Copyright 2019 Rochus Keller <mailto:me@rochus-keller.ch>
*
* This file is part of the Oberon parser/code model library.
*
* The following is the license that applies to this copy of the
* library. For a license to use the library under conditions
* other than those described here, please email to me@rochus-keller.ch.
*
* GNU General Public License Usage
* This file may be used under the terms of the GNU General Public
* License (GPL) versions 2.0 or 3.0 as published by the Free Software
* Foundation and appearing in the file LICENSE.GPL included in
* the packaging of this file. Please review the following information
* to ensure GNU General Public Licensing requirements will be met:
* http://www.fsf.org/licensing/licenses/info/GPLv2.html and
* http://www.gnu.org/copyleft/gpl.html.
*/

#include <QCoreApplication>
#include <QtDebug>
#include <QTextStream>
#include <QFileInfo>
#include <QDir>
#include "LlLSC.h"
#include "LlLSB.h"
#include "LlLSV.h"
#include "LlLSP.h"
#include "LlTexts.h"

static QByteArray tag( int t )
{
    switch( t )
    {
    case Ll::LSB::const_:
        return "const";
    case Ll::LSB::typ:
        return "typ";
    case Ll::LSB::var:
        return "var";
    case Ll::LSB::lit:
        return "lit";
    case Ll::LSB::sel:
        return "sel";
    case Ll::LSB::range:
        return "range";
    case Ll::LSB::cons:
        return "cons";
    case Ll::LSB::repl:
        return "repl";
    case Ll::LSB::not_:
        return "not";
    case Ll::LSB::and_:
        return "and";
    case Ll::LSB::mul:
        return "mul";
    case Ll::LSB::div:
        return "div";
    case Ll::LSB::or_:
        return "or";
    case Ll::LSB::xor_:
        return "xor";
    case Ll::LSB::add:
        return "add";
    case Ll::LSB::sub:
        return "sub";
    case Ll::LSB::eql:
        return "eql";
    case Ll::LSB::neq:
        return "neq";
    case Ll::LSB::lss:
        return "lss";
    case Ll::LSB::geq:
        return "geq";
    case Ll::LSB::leq:
        return "leq";
    case Ll::LSB::gtr:
        return "gtr";
    case Ll::LSB::then:
        return "then";
    case Ll::LSB::else_:
        return "else";
    case Ll::LSB::ts:
        return "ts";
    case Ll::LSB::next:
        return "next";
    }
    return "?";
}

static QSet<const void*> visited;

static QByteArray ws(int level )
{
    QByteArray ws;
    for( int i = 0; i < level; i++ )
       // ws += "|  ";
        ws += "  ";
    return ws;
}

static void dump( const Ll::LSB::ItemDesc* item, QTextStream& out, int level );

static void dump( const Ll::LSB::TypeDesc* type, QTextStream& out, int level )
{
    const Ll::LSB::ArrayTypeDesc* arr = dynamic_cast<const Ll::LSB::ArrayTypeDesc*>(type);
    const Ll::LSB::UnitTypeDesc* unit = dynamic_cast<const Ll::LSB::UnitTypeDesc*>(type);
    if( arr )
        out << "ARRAY ";
    else if( unit )
        out << "UNIT ";
    else
        out << "TYPE ";
    out << "len=" << type->len << " ";
    out << "size=" << type->size;
    if( visited.contains(type) )
    {
        out << " ..." << endl;
        return;
    }else
        visited.insert(type);
    out << endl;
    if( arr && arr->eltyp )
    {
        out << ws(level+1) << "eltyp: ";
        dump(arr->eltyp, out, level+1 );
    }
    if( unit && unit->firstobj )
    {
        out << ws(level+1) << "firstobj: ";
        dump(unit->firstobj, out, level+1 );
    }
    if( type->typobj )
    {
        out << ws(level+1) << "typobj: ";
        dump(type->typobj, out, level+1 );
    }
}

static void dump( const Ll::LSB::ItemDesc* item, QTextStream& out, int level )
{
    const Ll::LSB::ObjDesc* obj = dynamic_cast<const Ll::LSB::ObjDesc*>(item);

    // For each declared identifier an instance of type Object is generated.
    if( obj )
        out << "OBJECT '" << obj->name.data() << "' ";
    else
        out << "ITEM ";
    out << "tag=" << tag(item->tag) << " ";
    out << "size=" << item->size << " ";
    out << "val=" << item->val;
    if( visited.contains(item) )
    {
        out << " ..." << endl;
        return;
    }else
        visited.insert(item);
    out << endl;

    if( item->type )
    {
        out << ws(level+1) << "type: ";
        dump(item->type,out,level+1);
    }
    if( item->a )
    {
        out << ws(level+1) << "a: ";
        dump(item->a,out,level+1);
    }
    if( item->b )
    {
        out << ws(level+1) << "b: ";
        dump(item->b,out,level+1);
    }

    if( obj && obj->next )
    {
        out << ws(level);
        dump( obj->next, out, level );
    }
}

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    QTextStream out(stdout);

    out << "Lolac version 19-04-21/c++" << endl
        << "see https://github.com/rochus-keller/Lolac for more information" << endl;

    if( QCoreApplication::arguments().size() == 1 )
    {
        out << "Usage: Lolac [options] inFile [outFile]" << endl;
        return 0;
    }

    QStringList files;
    bool printTree = false;
    const QStringList args = QCoreApplication::arguments();
    for( int i = 1; i < args.size(); i++ ) // arg 0 enthaelt Anwendungspfad
    {
        if( args[i].startsWith( "-p" ) )
            printTree = true;
        else if( !args[ i ].startsWith( '-' ) )
        {
            files += args[ i ];
        }else
        {
            qDebug() << "invalid command line parameter" << args[i];
            return -1;
        }
    }
    if( files.isEmpty() || files.size() > 2 )
    {
        qCritical() << "expecting an input and optional output file path";
        return -1;
    }

    const QByteArray infile = files.first().toUtf8();
    QByteArray outfile;
    QFileInfo fi(files.first());
    if( files.size() > 1 )
        outfile = files.last().toUtf8();
    else
        outfile = fi.dir().absoluteFilePath(fi.baseName() + QString(".v")).toUtf8();

    try
    {
        Ll::LSC::_inst()->Compile(infile.constData());
        if( printTree )
        {
            QFile txt( fi.dir().absoluteFilePath(fi.baseName() + QString(".txt")) );
            txt.open(QIODevice::WriteOnly );
            QTextStream out2(&txt);
            dump( Ll::LSB::_inst()->top, out2, 0 );
        }
        //Ll::LSP::_inst()->List();
        Ll::LSV::_inst()->List(outfile.constData());
        Ll::_Root::deleteArena();
    }catch( const char* str )
    {
        qCritical() << str;
        return -1;
    }catch( ... )
    {
        qCritical() << "unknown exception";
        return -1;
    }

    return 0 ;
}
