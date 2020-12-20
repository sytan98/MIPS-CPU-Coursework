int bin_seq(int x)
{
    if(x>0)
	{
		return 2*bin_seq(x-1);
	}
    else if(x == 0)
	{
		return 1;
	}
    else{}
}
