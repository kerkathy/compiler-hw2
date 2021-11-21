# hw2 report

|||
|-:|:-|
|Name|Ko Ting-Wen|
|ID|0710025|

## How much time did you spend on this project

about 6 hrs

## Project overview
> Please describe the structure of your code and the ideas behind your implementation in an organized way. \

In the very beginning, I wrote down all the CFGs needed to complete this hw by reading through README.md. In this way, I can clearly see the grammars, terminals, and nonterminals I need.

Then I start coding.

First, declare all terminals and operators respectively using `%token` and `left` (since they are left associative) in declarations area.
Note that the operators are sorted in precedence order.
```yacc
%token ID SEMI BEG END LEFT_PRN RIGHT_PRN COLON COMMA ASSIGN IF THEN ELSE PRINT READ LEFT_BRKT RIGHT_BRKT WHILE DO FOR TO RETURN VAR ARRAY OF DEF 
%token INTEGER INT_NUM REAL REAL_NUM STRING STR_LIT BOOL TRUE FALSE
%left AND OR NOT
%left LESS LESS_EQU NOT_EQU GREATER_EQU GREATER EQU
%left SUB
%left ADD
%left DIV MOD
%left MUL
```
Then, start to implement all CFGs. 

Note that we must derive every nonterminal created by ourselves.

For those "zero or more..." declarations, I use `...list` as a naming convention, including:
* `var_const_decl_list`: holds zero or more variable and constant declaration
* `func_decl_def_list`: holds zero or more function declaration and definition
* `arg_list`: holds zero or more formal arguments, separated by semicolons
* `id_list`: holds zero or more identifiers
* `brkt_list`: holds zero or more brackets
* `stmt_list`: holds zero or more statements
* `expr_list`: holds zero or more expressions


Some of the lists hold more than one tokens. In that case, replace `arg` in 
```yacc
argseq : /* empty */ | argseq1 ;

argseq1 : arg | argseq1 ',' arg ;
```
as
```yacc
argseq : /* empty */ | argseq1 ;

argseq1 : arg_1 | arg_2 |... | argseq1 ',' arg_1 | argseq1 ',' arg_2 | ... ;
```
such as 
```yacc
var_const_decl_list: /**/ | var_const_decl_list1 {};
var_const_decl_list1: var_decl {} | const_decl {} 
                    | var_const_decl_list var_decl {}
                    | var_const_decl_list const_decl {};
func_decl_def_list: /**/ | func_decl_def_list1 {};
func_decl_def_list1: func_decl {} | func_def {}
                   | func_decl_def_list1 func_decl {}
                   | func_decl_def_list1 func_def {};
```

As for the data type, the structured array type is worth noting. Because the dimension of an array isn't specified, it could be more than 2. For example, `array 4 of array 3 of array 3 of integer`. I declare a nonterminal `arr_type` to deal with it. 
```yacc
type: scal_type | arr_type;
scal_type: INTEGER {} | REAL {} | STRING {} | BOOL {};
arr_type: ARRAY INT_NUM OF type {};
```

I name the constants with suffix `NUM` or `LIT` (which stands for literal). 
```yacc
lit_const: INT_NUM {} | REAL_NUM {} | STR_LIT {} | TRUE {} | FALSE {};
```
The `BEGIN` is named as `BEG` to prevent confusion with keyword `BEGIN`.

I created two versions for function call, `func_call` and `func_call_nosemi`. The only difference lies in the existence of semicolon in the end.
```yacc
func_call: ID LEFT_PRN expr_list RIGHT_PRN SEMI {};
func_call_nosemi: ID LEFT_PRN expr_list RIGHT_PRN {};
```

As for the arithmetic expression, I used `%prec` to specify the precedence of the `-` sign so that subtraction and negation has different precedence level. Besides, we need to create the rule that covers `arith_expr` in parenthesis.
```yacc
arith_expr: ...
		  | NOT arith_expr {}
		  ...
		  | SUB arith_expr %prec MUL {}
		  | LEFT_PRN arith_expr RIGHT_PRN {} 
		  ...
```


After `parser.y` is finished, switch to `scanner.l` to return the tokens we asked for in `parser.y`. Note that scientific notation should be returned as `REAL_NUM`.


## What is the hardest you think in this project

It's not hard to finish this homework since the instruction in `README.md` is super clear.

However, I confuse `INTEGER` (which is a data type) and `INT_NUM` at first. Thus, I think it's crucial to understand the meaning of each token.

To conclude, I think the hardest part maybe is to understand how scanner and parser interact with each other.

And don't forget to add `SEMI` (which refers to semicolon `;`) in the end of some grammar.

## Feedback to T.A.s

`README.md` is super clear! Thanks a lot.
