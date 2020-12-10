int oo(int x)
{
	return x&0xf0f0;
}
int start(int x)
{
	return 7 + oo(x);
}
