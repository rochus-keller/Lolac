// Generated by OberonViewer 0.6 on 2019-04-14T11:52:49
#include "LlLSV.h"
#include <memory>
using namespace Ll;

static std::auto_ptr<LSV> s_inst;


LSV* LSV::_inst()
{
	if( s_inst.get() == 0 )
		s_inst.reset( new LSV() );
	return s_inst.get();
}

void LSV::Write(char ch)
{
	// BEGIN
	LSV* _this = _inst();
	Files::_inst()->Write(_this->R, ch);
	// END
}

void LSV::WriteLn()
{
	// BEGIN
	LSV* _this = _inst();
	Files::_inst()->Write(_this->R, 0x0D);
	Files::_inst()->Write(_this->R, 0x0A);
	// END
}

/*  x >= 0  */
void LSV::WriteInt(int x)
{
	// VAR
	int i;
	_FxArray<int,14> d;

	// BEGIN
	LSV* _this = _inst();
	i = 0;
	if( x < 0 )
	{
		Files::_inst()->Write(_this->R, '-');
		x = -x;
	}
	do 
	{
		d[i] = x % 10;
		x = x / 10;
		i++;
	} while( !( x == 0 ) );
	do 
	{
		i--;
		Files::_inst()->Write(_this->R, char( d[i] + 0x30 ));
	} while( !( i == 0 ) );
	// END
}

/* x >= 0 */
void LSV::WriteHex(int x)
{
	// VAR
	int i;
	_FxArray<int,8> d;

	// BEGIN
	LSV* _this = _inst();
	i = 0;
	do 
	{
		d[i] = x % 0x10;
		x = x / 0x10;
		i++;
	} while( !( (x == 0) || (i == 8) ) );
	do 
	{
		i--;
		if( d[i] >= 10 )
			Files::_inst()->Write(_this->R, char( d[i] + 0x37 ));
		else
			Files::_inst()->Write(_this->R, char( d[i] + 0x30 ));

	} while( !( i == 0 ) );
	// END
}

void LSV::WriteString(_ValArray<char> s)
{
	// VAR
	int i;

	// BEGIN
	LSV* _this = _inst();
	i = 0;
	while( s[i] != 0x0 )
	{
		Files::_inst()->Write(_this->R, s[i]);
		i++;
	}
	// END
}

/*  -------------------------------  */
void LSV::Type(LSB::Type typ)
{
	// VAR
	LSB::Object obj;

	// BEGIN
	LSV* _this = _inst();
	if( dynamic_cast<LSB::ArrayType>(typ) != 0  )
	{
		if( typ->_to<LSB::ArrayType>()->eltyp != LSB::_inst()->bitType )
		{
			_this->Write('[');
			_this->WriteInt(typ->len - 1);
			_this->WriteString(":0]");
			_this->Type(typ->_to<LSB::ArrayType>()->eltyp);
		}
	}else if( dynamic_cast<LSB::UnitType>(typ) != 0  )
		; // empty statement
	
	// END
}

/*  obj := typ(LSB.UnitType).firstobj;  */
void LSV::BitArrLen(LSB::Type typ)
{
	// VAR
	LSB::Type eltyp;

	// BEGIN
	LSV* _this = _inst();
	if( dynamic_cast<LSB::ArrayType>(typ) != 0  )
	{
		eltyp = typ->_to<LSB::ArrayType>()->eltyp;
		while( dynamic_cast<LSB::ArrayType>(eltyp) != 0  )
		{
			typ = eltyp;
			eltyp = typ->_to<LSB::ArrayType>()->eltyp;
		}
		if( eltyp == LSB::_inst()->bitType )
		{
			_this->Write('[');
			_this->WriteInt(typ->len - 1);
			_this->WriteString(":0] ");
		}
	}
	// END
}

void LSV::Expression(LSB::Item x)
{
	// VAR
	LSB::Item z;

	// BEGIN
	LSV* _this = _inst();
	if( x != 0 )
	{
		if( dynamic_cast<LSB::Object>(x) != 0  )
			_this->WriteString(x->_to<LSB::Object>()->name);
		else if( x->tag == LSB::_inst()->cons )
		{
			_this->Write('{');
			_this->Constructor(x);
			_this->Write('}');
		}else
		{
			if( x->tag == LSB::_inst()->repl )
			{
				_this->Write('{');
				_this->WriteInt(x->b->val);
				_this->Write('{');
				_this->Expression(x->a);
				_this->Write('}');
				_this->Write('}');
			}else
			{
				if( (x->tag >= LSB::_inst()->and_) && (x->tag <= LSB::_inst()->then) )
					_this->Write('(');
				
				_this->Expression(x->a);
				if( x->tag == LSB::_inst()->sel )
				{
					_this->Write('[');
					_this->Expression(x->b);
					_this->Write(']');
				}else if( x->tag == LSB::_inst()->lit )
				{
					if( x->size != 0 )
					{
						_this->WriteInt(x->size);
						_this->Write('\'');
						_this->Write('h');
						_this->WriteHex(x->val);
					}else
						_this->WriteInt(x->val);

				}else
				{
					_this->WriteString(_this->C[x->tag]);
					_this->Expression(x->b);
				}
				if( (x->tag >= LSB::_inst()->and_) && (x->tag <= LSB::_inst()->then) )
					_this->Write(')');
				
			}
		}
	}
	// END
}

void LSV::Elem(LSB::Item& x)
{
	// BEGIN
	LSV* _this = _inst();
	if( x->tag == LSB::_inst()->repl )
	{
		_this->Write('{');
		_this->WriteInt(x->b->val);
		_this->Write('{');
		_this->Expression(x->a);
		_this->WriteString("}}");
	}else
		_this->Expression(x);

	// END
}

void LSV::Constructor0(LSB::Item& x)
{
	// BEGIN
	LSV* _this = _inst();
	if( x->tag == LSB::_inst()->cons )
	{
		_this->Constructor(x->a);
		_this->WriteString(", ");
		_this->Elem(x->b);
	}else
		_this->Elem(x);

	// END
}

void LSV::Declaration(LSB::Object obj)
{
	// VAR
	LSB::Item apar;
	LSB::Type typ;

	// BEGIN
	LSV* _this = _inst();
	typ = obj->type;
	if( dynamic_cast<LSB::UnitType>(obj->type) != 0  )
		_this->WriteString("unit ");
	else
		_this->Type(obj->type);

	if( obj->tag == LSB::_inst()->var )
	{
		if( dynamic_cast<LSB::UnitType>(obj->type) != 0  )
		{
			apar = obj->a;
			_this->WriteLn();
			_this->Write('[');
			while( apar != 0 )
			{
				_this->Expression(apar->b);
				apar = apar->a;
			}
			_this->Write(']');
		}
	}else if( obj->tag == LSB::_inst()->const_ )
	{
		_this->WriteString(" = ");
		_this->WriteInt(obj->val);
	}
	// END
}

/* declarations */
void LSV::ObjList0(LSB::Object obj)
{
	// VAR
	LSB::Object obj1;
	bool param;

	// BEGIN
	LSV* _this = _inst();
	param = true;
	while( obj != LSB::_inst()->root )
	{
		if( (obj->tag == LSB::_inst()->var) && !(dynamic_cast<LSB::UnitType>(obj->type) != 0 ) )
		{
			if( obj->val == 0 )
				_this->WriteString("reg ");
			else if( obj->val == 2 )
				_this->WriteString("wire ");
			else if( obj->val == 3 )
				_this->WriteString("output ");
			else if( obj->val == 5 )
				_this->WriteString("inout ");
			else if( obj->val == 6 )
				_this->WriteString("input ");
			else
				_this->WriteString("??? ");

			_this->BitArrLen(obj->type);
			_this->WriteString(obj->name);
			obj1 = obj->next;
			while( (obj1 != LSB::_inst()->root) && (obj1->type == obj->type) && (obj1->val == obj->val) )
			{
				_this->WriteString(", ");
				obj = obj1;
				_this->WriteString(obj->name);
				obj1 = obj->next;
			}
			/* end param list */
			if( param && (obj->val >= 3) && (obj1->val < 3) )
			{
				param = false;
				_this->Write(')');
			}
			if( (obj->type != LSB::_inst()->bitType) && (obj->type->_to<LSB::ArrayType>()->eltyp != LSB::_inst()->bitType) )
				_this->Type(obj->type);
			
			if( param )
				_this->Write(',');
			else
				_this->Write(';');

			_this->WriteLn();
		}else if( obj->tag == LSB::_inst()->const_ )
			; // empty statement
		
		obj = obj->next;
	}
	// END
}

void LSV::ActParam(LSB::Item& x, LSB::Object fpar)
{
	// BEGIN
	LSV* _this = _inst();
	_this->Write('.');
	_this->WriteString(fpar->name);
	_this->Write('(');
	_this->Expression(x);
	_this->Write(')');
	// END
}

/* assignments to variables */
void LSV::ObjList1(LSB::Object obj)
{
	// VAR
	LSB::Item apar;
	LSB::Item x;
	LSB::Object fpar;
	int size;

	// BEGIN
	LSV* _this = _inst();
	while( obj != LSB::_inst()->root )
	{
		if( (obj->tag == LSB::_inst()->var) || (obj->tag == LSB::_inst()->const_) )
		{
			if( dynamic_cast<LSB::UnitType>(obj->type) != 0  )
			{
				_this->WriteString(obj->type->typobj->name);
				_this->Write(' ');
				_this->WriteString(obj->name);
				apar = obj->b;
				fpar = obj->type->_to<LSB::UnitType>()->firstobj;
				/* actual param list */
				_this->Write('(');
				_this->ActParam(apar->b, fpar);
				apar = apar->a;
				fpar = fpar->next;
				while( apar != 0 )
				{
					_this->WriteString(", ");
					_this->ActParam(apar->b, fpar);
					apar = apar->a;
					fpar = fpar->next;
				}
				_this->Write(')');
				_this->Write(';');
				_this->WriteLn();
			}else if( (obj->b != 0) && (obj->val == 5) )
			{
				/* tri-state */
				size = obj->type->size;
				x = obj->b;
				if( x->tag == LSB::_inst()->ts )
				{
					if( obj->type == LSB::_inst()->bitType )
					{
						_this->WriteString("IOBUF block");
						_this->nofgen++;
						_this->WriteInt(_this->nofgen);
						_this->WriteString(" (.IO(");
						_this->WriteString(obj->name);
						_this->WriteString("), .O(");
						_this->WriteString(x->a->_to<LSB::Object>()->name);
						_this->WriteString("), .I(");
						x = x->b;
						if( x->a->type == LSB::_inst()->bitType )
							_this->Expression(x->a);
						else
							_this->WriteString(x->a->_to<LSB::Object>()->name);

						_this->WriteString("), .T(");
						if( x->b->type == LSB::_inst()->bitType )
							_this->Expression(x->b);
						else
							_this->WriteString(x->b->_to<LSB::Object>()->name);

						_this->WriteString("));");
					}else
					{
						/* array type */
						if( _this->nofgen == 0 )
						{
							_this->WriteString("genvar i;");
							_this->WriteLn();
						}
						_this->nofgen++;
						_this->WriteString("generate");
						_this->WriteLn();
						_this->WriteString("for (i = 0; i < ");
						_this->WriteInt(size);
						_this->WriteString("; i = i+1) begin : bufblock");
						_this->WriteInt(_this->nofgen);
						_this->WriteLn();
						_this->WriteString("IOBUF block (.IO(");
						_this->WriteString(obj->name);
						_this->WriteString("[i]), .O(");
						_this->WriteString(x->a->_to<LSB::Object>()->name);
						_this->WriteString("[i]), .I(");
						x = x->b;
						_this->WriteString(x->a->_to<LSB::Object>()->name);
						_this->WriteString("[i]), .T(");
						if( x->b->type == LSB::_inst()->bitType )
							_this->Expression(x->b);
						else
						{
							_this->WriteString(x->b->_to<LSB::Object>()->name);
							_this->WriteString("[i]");
						}
						_this->WriteString("));");
						_this->WriteLn();
						_this->WriteString("end");
						_this->WriteLn();
						_this->WriteString("endgenerate");
					}
					_this->WriteLn();
				}
			}else if( (obj->b != 0) && (obj->val >= 2) )
			{
				_this->WriteString("assign ");
				_this->WriteString(obj->name);
				if( (obj->a != 0) )
				{
					_this->Write('[');
					_this->Expression(obj->a);
					_this->Write(']');
				}
				_this->WriteString(" = ");
				_this->Expression(obj->b);
				_this->Write(';');
				_this->WriteLn();
			}
		}else if( obj->tag == LSB::_inst()->typ )
			; // empty statement
		
		/* instantiation; actual parameters */
		obj = obj->next;
	}
	// END
}

/* assignments to registers */
void LSV::ObjList2(LSB::Object obj)
{
	// VAR
	LSB::Item clk;

	// BEGIN
	LSV* _this = _inst();
	while( obj != LSB::_inst()->root )
		if( (obj->tag == LSB::_inst()->var) && !(dynamic_cast<LSB::UnitType>(obj->type) != 0 ) && (obj->val == 0) )
		{
			_this->WriteString("always @ (posedge ");
			clk = obj->a;
			_this->Expression(clk);
			_this->WriteString(") begin ");
			do 
			{
				_this->WriteString(obj->name);
				_this->WriteString(" <= ");
				_this->Expression(obj->b);
				_this->Write(';');
				_this->WriteLn();
				obj = obj->next;
			} while( !( (obj == LSB::_inst()->top) || (obj->a != clk) ) );
			_this->WriteString("end");
			_this->WriteLn();
		}else
			obj = obj->next;

	
	// END
}

/*  modified by Rochus  */
void LSV::List(_ValArray<char> file)
{
	// BEGIN
	LSV* _this = _inst();
	Texts::_inst()->WriteString(_this->W, LSB::_inst()->modname);
	Texts::_inst()->WriteString(_this->W, " translating to  ");
	Texts::_inst()->WriteString(_this->W, file);
	_this->F = Files::_inst()->New(file);
	Files::_inst()->Set(_this->R, _this->F, 0);
	_this->WriteString("`timescale 1ns / 1 ps");
	_this->WriteLn();
	_this->nofgen = 0;
	_this->WriteString("module ");
	_this->WriteString(LSB::_inst()->modname);
	_this->WriteString("(   // translated from Lola");
	_this->WriteLn();
	_this->ObjList0(LSB::_inst()->top);
	_this->ObjList1(LSB::_inst()->top);
	_this->ObjList2(LSB::_inst()->top);
	_this->WriteString("endmodule");
	_this->WriteLn();
	Files::_inst()->Register(_this->F);
	Texts::_inst()->WriteString(_this->W, " done");
	Texts::_inst()->WriteLn(_this->W);
	Texts::_inst()->Append(Oberon::_inst()->Log, _this->W.buf);
	// END
}

LSV::LSV()
{
	// BEGIN
	Texts::_inst()->OpenWriter(W);
	Constructor = Constructor0;
	C[LSB::_inst()->const_] = "CONST";
	C[LSB::_inst()->typ] = "TYPE";
	C[LSB::_inst()->var] = "VAR";
	C[LSB::_inst()->lit] = "LIT";
	C[LSB::_inst()->sel] = "SEL";
	C[LSB::_inst()->range] = ':';
	C[LSB::_inst()->cons] = ',';
	C[LSB::_inst()->or_] = " | ";
	C[LSB::_inst()->xor_] = " ^ ";
	C[LSB::_inst()->and_] = " & ";
	C[LSB::_inst()->not_] = '~';
	C[LSB::_inst()->add] = " + ";
	C[LSB::_inst()->sub] = " - ";
	C[LSB::_inst()->mul] = " * ";
	C[LSB::_inst()->div] = " / ";
	C[LSB::_inst()->eql] = " == ";
	C[LSB::_inst()->neq] = " != ";
	C[LSB::_inst()->lss] = " <  ";
	C[LSB::_inst()->geq] = " >= ";
	C[LSB::_inst()->leq] = " <= ";
	C[LSB::_inst()->gtr] = " >  ";
	C[LSB::_inst()->then] = " ? ";
	C[LSB::_inst()->else_] = " : ";
	C[LSB::_inst()->ts] = "TS";
	C[LSB::_inst()->next] = "--";
	// END
}

LSV::~LSV()
{
	s_inst.release();
}

