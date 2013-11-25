#include <stdlib.h>
#include <string.h>
#include <stdio.h>

void emit_symbol(char *type, char *ss, char *se, int lc) {
	printf( "%s(%i): ", type, lc );
	fwrite( ss, 1, se-ss, stdout );
	printf("\n");
}

%%{	machine	yamlparser;
	action got_real { emit_symbol("Real", ts,te, linecount); }
	action got_int { emit_symbol("Int", ts,te, linecount); }
	action got_ident { int level = te-(ts+1);
		if (level<indentation) {
			fhold;
			printf("..ret (%i)\n", level);
			fret;
		}
		indentation = level;
		printf("level %i\n", level);
	}
	action got_comment { emit_symbol("Comment", ts,te-1, linecount); }
	action got_newline {linecount += 1;}
	action got_sequnece {emit_symbol("Seq", ts,te-1, linecount);}

	fract = '.' digit+;
	nl = '\n' @got_newline;
	sign = '+'|'-';
	exponent = [eE] sign digit+;
	Real = sign? (digit+ '.' digit+);
	Int = digit+;
	Ident = ([A-Za-z\:]+);
	Comment = '#' [^\n]* nl;

	Object := |*
		Real => got_real;
		Int => got_int;
		'-' ' '* => got_sequnece;
		nl [ \t]* => got_ident;
		nl [^ \t]=> {fhold;indentation=0;printf("..ret (0)\n");fret;};
		[A-Za-z][A-Za-z ]* ':' => {emit_symbol("Object", ts,te-1, linecount);
			fcall Object;};
		Comment => got_comment;
		[ \t] {printf("_");};
	*|;

	main := |*
		Comment => got_comment;
		[A-Za-z ]* ':' => {emit_symbol("Object", ts,te-1, linecount);
			fcall Object;};
	*|;
	write data nofinal;
}%%
//	TODO: Read http://yaml.org/spec/1.0/

/*!	Scan a string and return a set of YAML documents

	\parameter input The Z-terminated string to scan.
	\retruns a graph-structure representing the input.
*/void *yamil_scan(const char *input) {
	int cs, act, top,
		linecount = 0,
		indentation = 0;
	char *eof, *ts, *te = 0,
		*p = input,
		*pe = eof = p+strlen(input);
	int *stack = malloc(sizeof(int*)*64);
	%%{
		write init;
		write exec;
	}%%
	printf("====\nlines: %i\n", linecount);
	free(stack);
	return NULL;
}
