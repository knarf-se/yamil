#include <stdlib.h>
#include <string.h>
#include <stdio.h>

%%{	machine	yamlparser;
	fract = '.' digit*;
	nl = '\n' @{linecount += 1;};
	Scalar = fract | digit;
	Sequence = ('- '.Scalar)*;
	main := (Scalar nl?)*;
	write data nofinal;
}%%
//	TODO: Read http://yaml.org/spec/1.0/

void *yaml_scan(const char *input) {
	int cs, linecount = 0;
	char *p = input,
		*pe = p+strlen(input);
	%%{
		write init;
		write exec;
	}%%
	return NULL;
}
