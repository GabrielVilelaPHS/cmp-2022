%{


	#include <stdio.h>
	#include "header.h"
	#include "calc.tab.h"
%}


%option yylineno

D 	[0-9]
L 	[a-zA-Z_]
 
%%



 /*" { comment();}*/

[ \t\r\n]	{}
"print" 	{ return TOK_PRINT; }
"="		{ return '='; }
"*"		{ return '*'; }
"/"		{ return '/'; }
"+"		{ return '+'; }
"-"		{ return '-'; }
"("		{ return '('; }
")"		{ return ')'; }
"^"		{ return '^'; }
"%"		{ return '%'; }

{D}+		{ yylval.args.intv = atoi(yytext); return TOK_INTEGER; }
{D}+\.{D}+ 	{ yylval.args.dblv = atof(yytext); return TOK_FLOAT; }
{L}({L}|{D})*	{ yylval.args.ident = strndup(yytext, yyleng); return TOK_IDENT; }
 /*{L}({L}|{D})*	{ yylval.args.lit = strndup(yytext, yyleng); return TOK_LITERAL; }*/


 /* ("){L}({L}|{D})*(")	{ return TOK_LITERAL; }*/ 

.		{ printf("Invalid caracter: %c.\n", yytext[0]); }

%%

int yywrap(){
	return 1;
}

int main(int argc, char *argv[]){ /*args passa argumentos na linha de comando*/
	
	if (argc <= 1){
		printf("%s [file]\n", argv[0]);
		return 1;
	}
	
	FILE *f = fopen(argv[1],"r");
	yyin = f; /*infoma que eu quero copilar o arqruivo que estou*/
	yyparse(); /*manda copilar*/
	fclose(f);
	
	return 0;

}
