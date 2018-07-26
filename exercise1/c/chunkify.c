#include <stdio.h>
#include <string.h>
#include <stdlib.h>

enum
{
	SYNERR = 1,
	STRERR,
	CHKERR,
	ERRLEN
};

int chunkify(char *string, int chunk_length, char fill)
{
	int i, len, rlen;

	if (!string)
	{
		printf("input string is null\n");
		return STRERR;
	}

	if (chunk_length == 0)
	{
		printf("chunk length is zero\n");
		return CHKERR;
	}

	len = strlen(string);
	rlen = len - (len % chunk_length);

	printf("[");

	for (i = 0; i < rlen; i += chunk_length)
	{
		int next = i + chunk_length;
		char tmp = string[next];

		string[next] = '\0';
		printf("\'%s\'", &string[i]);
		string[next] = tmp;

		if (next < rlen)
			printf(", ");
	}

	if (len > rlen)
	{
		int fills = chunk_length - (len % chunk_length);

		string += rlen;
		printf(", \'%s", string);

		for (i = 0; i < fills; i++)
			printf("%c", fill);

		printf("'");
	}

	printf("]\n");
}

int main(int argc, char **argv)
{
	char fill = 'x';

	if (argc < 3 || argc > 4)
	{
		printf("usage: %s <string> <chunklen> <filler>\n", argv[0]);
		return SYNERR;
	}

	if (argc == 4)
		fill = argv[3][0];

	return chunkify(argv[1], atoi(argv[2]), fill);
}
