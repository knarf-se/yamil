#include <stdlib.h>
#include <string.h>
#include <stdio.h>

%%{	machine	yamlparser;
	fract = '.' digit+;
	nl = '\n' @{linecount += 1;};
	sign = '+'|'-';
	exponent = [eE] sign digit+;
	Real = (sign? digit+ fract?)|fract;
	Scalar = fract | digit;
	Sequence = ('- '.Scalar)*;
	Document = (Scalar nl?)*;
	main := (Document '---')* | Document '...'?;
	write data nofinal;
}%%
//	TODO: Read http://yaml.org/spec/1.0/

/*!	Scan a string and return a set of YAML documents

	\parameter input The Z-terminated string to scan.
	\retruns a graph-structure representing the input.
*/void *yaml_scan(const char *input) {
	int cs, linecount = 0;
	char *p = input,
		*pe = p+strlen(input);
	%%{
		write init;
		write exec;
	}%%
	return NULL;
}
