#include<stdio.h>


int sum2(int a, int b)
{return a+b; }

int main()
{
	int n = 1000000000;
	int i = 0;
	int i1 = 1;
	int i2 = 2;
	int i3 = 3;
	for (i = 1; i <= n; i++)
		i1 = sum2(i, i3);
}
