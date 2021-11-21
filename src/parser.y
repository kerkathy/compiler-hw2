%{
#include <assert.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

extern int32_t line_num;  /* declared in scanner.l */
extern char buffer[];     /* declared in scanner.l */
extern FILE *yyin;        /* declared by lex */
extern char *yytext;      /* declared by lex */

extern int yylex(void); 
static void yyerror(const char *msg);
%}

/*BEG is short for BEGIN, since BEGIN is a reserved word */
%token ID SEMI BEG END LEFT_PRN RIGHT_PRN COLON COMMA ASSIGN IF THEN ELSE PRINT READ LEFT_BRKT RIGHT_BRKT WHILE DO FOR TO RETURN VAR ARRAY OF DEF 
%token INTEGER INT_NUM REAL REAL_NUM STRING STR_LIT BOOL TRUE FALSE
%left AND OR NOT
%left LESS LESS_EQU NOT_EQU GREATER_EQU GREATER EQU
%left SUB
%left ADD
%left DIV MOD
%left MUL


%%

/*ProgramName: ID */
program: ID SEMI var_const_decl_list func_decl_def_list comp_stmt END {};
func_decl: ID LEFT_PRN arg_list RIGHT_PRN COLON scal_type SEMI {}
		 | ID LEFT_PRN arg_list RIGHT_PRN SEMI {};
func_def: ID LEFT_PRN arg_list RIGHT_PRN COLON scal_type comp_stmt END {}
		| ID LEFT_PRN arg_list RIGHT_PRN comp_stmt END {};
arg_list: /*empty*/ {} | arg_list1 {};
arg_list1: arg {} | arg_list COMMA arg {};
arg: id_list COLON type {};
id_list: ID {}
	   | id_list COMMA ID {};
var_decl: VAR id_list COLON scal_type SEMI {}
		/*| VAR id_list COLON ARRAY int_const OF type SEMI {};*/
		| VAR id_list COLON ARRAY INT_NUM OF type SEMI {};
type: scal_type | arr_type;
scal_type: INTEGER {} | REAL {} | STRING {} | BOOL {};
arr_type: ARRAY INT_NUM OF type {};
const_decl: VAR id_list COLON lit_const SEMI {};
/*int_const: INT_NUM {};*/
lit_const: INT_NUM {} | REAL_NUM {} | STR_LIT {} | TRUE {} | FALSE {};
stmt: comp_stmt {} | simp_stmt {} | cond_stmt {} | while_stmt {} | for_stmt {} | return_stmt {} | func_call {} ;
comp_stmt: BEG var_const_decl_list stmt_list END {};
simp_stmt: assign_stmt {} | print_stmt {} | read_stmt {};
assign_stmt: var_ref ASSIGN expr SEMI {};
print_stmt: PRINT expr SEMI {};
read_stmt: READ var_ref SEMI {};
var_ref: ID {} | arr_inf {};
arr_inf: ID brkt_list {};
brkt_list: /*empty*/ | brkt_list1 {};
brkt_list1: LEFT_BRKT expr RIGHT_BRKT {}
		  | brkt_list1 LEFT_BRKT expr RIGHT_BRKT {};
cond_stmt: IF expr THEN comp_stmt ELSE comp_stmt END IF {}
		 | IF expr THEN comp_stmt END IF {};
while_stmt: WHILE expr DO comp_stmt END DO {};
for_stmt: FOR ID ASSIGN INT_NUM TO INT_NUM DO comp_stmt END DO {};
/*for_stmt: FOR ID ASSIGN int_const TO int_const DO comp_stmt END DO {};*/
return_stmt: RETURN expr SEMI {};
func_call: ID LEFT_PRN expr_list RIGHT_PRN SEMI {};
func_call_nosemi: ID LEFT_PRN expr_list RIGHT_PRN {};
expr: lit_const {} | var_ref {} | func_call_nosemi {} | arith_expr {};
arith_expr: arith_expr AND arith_expr {}
		  | arith_expr OR arith_expr {}
		  | NOT arith_expr {}
		  | arith_expr LESS arith_expr {}
		  | arith_expr LESS_EQU arith_expr {}
		  | arith_expr NOT_EQU arith_expr {}
		  | arith_expr GREATER_EQU arith_expr {}
		  | arith_expr GREATER arith_expr {}
		  | arith_expr EQU arith_expr {}
		  | arith_expr SUB arith_expr {}
		  | arith_expr ADD arith_expr {}
		  | arith_expr DIV arith_expr {}
		  | arith_expr MOD arith_expr {}
		  | arith_expr MUL arith_expr {}
		  | SUB arith_expr %prec MUL {}
		  | LEFT_PRN arith_expr RIGHT_PRN {} 
		  | lit_const {} | var_ref {} | func_call_nosemi {} ;
var_const_decl_list: /**/ | var_const_decl_list1 {};
var_const_decl_list1: var_decl {} | const_decl {} 
					| var_const_decl_list var_decl {}
					| var_const_decl_list const_decl {};
func_decl_def_list: /**/ | func_decl_def_list1 {};
func_decl_def_list1: func_decl {} | func_def {}
				   | func_decl_def_list1 func_decl {}
				   | func_decl_def_list1 func_def {};
stmt_list: /**/ | stmt_list1 {};
stmt_list1: stmt {} | stmt_list1 stmt {}
		  | stmt_list1 stmt {};
expr_list: /**/ | expr_list1 {};
expr_list1: expr {} | expr_list1 COMMA expr {};


%%

void yyerror(const char *msg) {
    fprintf(stderr,
            "\n"
            "|-----------------------------------------------------------------"
            "---------\n"
            "| Error found in Line #%d: %s\n"
            "|\n"
            "| Unmatched token: %s\n"
            "|-----------------------------------------------------------------"
            "---------\n",
            line_num, buffer, yytext);
    exit(-1);
}

int main(int argc, const char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: ./parser <filename>\n");
        exit(-1);
    }

    yyin = fopen(argv[1], "r");
    if (yyin == NULL) {
        perror("fopen() failed:");
    }

    yyparse();

    printf("\n"
           "|--------------------------------|\n"
           "|  There is no syntactic error!  |\n"
           "|--------------------------------|\n");
    return 0;
}
