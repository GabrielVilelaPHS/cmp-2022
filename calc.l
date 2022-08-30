%{


	#include <stdio.h>

%}


%option yylineno

D 	[0-9]
L 	[a-zA-Z_]
 
%%



"/*" { comment();}

[ \t\r\n]	{}
"print" 	{ printf("TOK_PRINT\n"); }
"="		{ printf("TOK_EQUAL\n"); }
"*"		{ printf("TOK_MULTIPLY\n"); }
"+"		{ printf("TOK_PLUS\n"); }
"/"		{ printf("TOK_MINUS\n"); }
"("		{ printf("TOK_OP\n"); }
")"		{ printf("TOK_CP\n"); }

{D}+		{ printf("TOK_INTEGER<%s>\n", yytext); }
{D}\.{D}+ 	{ printf("TOK_FLOAT<%s>\n", yytext); }
{L}({L}|{D})*	{ printf("TOK_LITERAL<%s>\n", yytext); }

.		{ printf("Invalid caracter: %c.\n", yytext[0]); }

%%

int yywrap(){
	return 1;
}

int main(int argc, char *argv[]){ /*args passa argumentos na linha de comando*/
	
	if (argc <= 1){
		printf("%s [file]\n". argv[0]);
		return 1;
	}
	
	FILE *f = fopen(argv[1],"r");
	yyin = f; /*infoma que eu quero copilar o arqruivo que estou*/
	yylex(); /*manda copilar*/
	fclose(f);
	
	return 0;
