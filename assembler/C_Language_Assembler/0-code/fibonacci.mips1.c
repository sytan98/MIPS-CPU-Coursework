int START(int x){
	if (x<=1){
		return x;
	}
	return START(x-1)+START(x-2);
}