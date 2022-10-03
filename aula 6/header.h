#pragma once
#include <stdio.h>

// header.h

enum noh_type {PROGRAM, STMT, GENERIC, ASSIGN, SUM, MINUS, MULTI, DIVIDE, PRINT, PAREN, POW, IDENT, INTEGER, FLOAT}; //fazer para literal

typedef struct {
	int intv;
	double dblv;
	//char[200] lit;
	char *ident;
	
}token_args;

struct noh {
	int id ;
	enum noh_type type;
	int childcount;
	
	double dblv;
	int intv;
	//char[200] lit;
	
	char *name;
	
	struct noh *children[1];

};
typedef struct noh noh;

static const char *noh_type_names[]= {
	"program","stmt","generic", 
	"=", "+","-","*", "/", "print",
	"()","^","ident","int","float"
	
};


noh *create_noh(enum noh_type, int children);
void print(noh *root);
void print_rec(FILE *f, noh *root);




