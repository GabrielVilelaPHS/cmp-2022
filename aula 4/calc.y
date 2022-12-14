%{
#include <stdio.h>

#include "header.h"

%union {
	struct noh *no;
}



int yyerror(const char *s);
int yylex (void);

//#define YYERROR_VERBOSE 1
extern int yylineno;

%}

%define parse.error verbose

%token TOK_PRINT TOK_IDENT
%token TOK_INTEGER TOK_FLOAT TOK_LITERAL
%start program 

%type <no> program stmts stmt atribuicao aritmetica 
%type <no> term term2 factor

%%

program : stmts {}  { 
		noh *program = create_noh(PROGRAM, 1); 
		program->children[0] = $1;
		
		//chamada da arvore asbtrata
		//chamada da verificacao semantica
		//chamada da geracao de codigo
	}
	;
	
stmts : stmt stmts  { 
		$$ = create_noh(STMT, 2); 
		$$->children[0] = $1;
		$$->children[1] = $2;
		
	}
	| stmt  { 
		$$ = create_noh(STMT, 1); 
		$$->children[0] = $1;
		
	}
	;
	

stmt : atribuicao  { 
		$$ = create_noh(GENERIC, 1); 
		$$->children[0] = $1;
		
	}
	| TOK_PRINT aritmetica  { 
		$$ = create_noh(PRINT, 1); 
		$$->children[0] = $2;
		
	}
	;

atribuicao : TOK_IDENT '=' aritmetica { 
		$$ = create_noh(ASSIGN, 2); 
		noh *aux = create_noh(IDENT, 0);		//$$->children[0] = create_noh(IDENT, 0);
		aux->name = NULL;				//$$->children[0]->name = NULL;
		$$->children[0] = aux;				//apaga
		$$->children[1] = $3;
		
	}
	;
	
aritmetica : aritmetica '+' term  { 
		$$ = create_noh(SUM, 2); 
		$$->children[0] = $1;
		$$->children[1] = $3;
		
	}
	| aritmetica '-' term  { 
		$$ = create_noh(MINUS, 2); 
		$$->children[0] = $1;
		$$->children[1] = $3;
		
	}
	| term  { 
		$$ = create_noh(GENERIC, 1); 
		$$->children[0] = $1;
		
	}
	;
	

term : term '*' term2  { 
		$$ = create_noh(MULTI, 2); 
		$$->children[0] = $1;
		$$->children[1] = $3;
		
	}
	| term '/' term2 { 
		$$ = create_noh(DIVIDE, 2); 
		$$->children[0] = $1;
		$$->children[1] = $3;
		
	}
	| term2 { 
		$$ = create_noh(GENERIC, 1); 
		$$->children[0] = $1;
		
	}
	;
	
term2 : term2 '^' factor  { 
		$$ = create_noh(POW, 2); 
		$$->children[0] = $1;
		$$->children[1] = $3;
		
	}
	| factor  { 
		$$ = create_noh(GENERIC, 2); 
		$$->children[0] = $1;
		
	}
	;

factor : '('aritmetica')' { 
		$$ = create_noh(PAREN, 1); 
		$$->children[0] = $2;
		
	}
	| TOK_IDENT {
		$$ = create_noh(IDENT, 0); //(nome do n??, a quantidade de filho)
		$$->name = NULL;
	}
	| TOK_INTEGER {
		$$ = create_noh(INTEGER, 0); //(nome do n??, a quantidade de filho)
		$$->value = 0;
	}
	| TOK_FLOAT  {
		$$ = create_noh(FLOAT, 0); //(nome do n??, a quantidade de filho)
		$$->value = 0;
	}
	;



%%
	
int yyerror(const char *s){
	printf("Erro na linha %d: %s\n", yylineno, s);
	return 1;

}	

