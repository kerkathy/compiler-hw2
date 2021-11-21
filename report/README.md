# hw2 report

|||
|-:|:-|
|Name|Ko Ting-Wen|
|ID|0710025|

## How much time did you spend on this project

about 6 hrs

## Project overview

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
Then, start to implement all CFGs. Note that we must derive every nonterminal created by ourselves.
For those "zero or more..." declarations, I use `...list` as a naming convention, including:
* `var_const_decl_list`: holds zero or more variable and constant declaration
* `func_decl_def_list`: holds zero or more function declaration and definition
* `arg_list`: holds zero or more formal arguments, separated by semicolons
* `id_list`: holds zero or more identifiers
* `brkt_list`: holds zero or more brackets
* `stmt_list`: holds zero or more statements
* `expr_list`: holds zero or more expressions



> Please describe the structure of your code and the ideas behind your implementation in an organized way. \
> The point is to show us how you deal with the problems. It is not necessary to write a lot of words or paste all of your code here. 

## What is the hardest you think in this project

> Not required, but bonus point may be given.

## Feedback to T.A.s

> Not required, but bonus point may be given.
