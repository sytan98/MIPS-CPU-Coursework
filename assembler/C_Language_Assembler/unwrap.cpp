#include <iostream>
#include <string>
#include <vector>
using namespace std;

int main()
{
    vector<string>vec;
    vector<string>tru;
    while(!cin.fail())
    {

	string x;
        cin >> x;
	if(x.length()<7)
	{
	    vec.push_back(x);
	    //cout << x <<endl;
	}
        //cout << x << " size:" << x.length() << endl;
    }
    for(int i=0;i<vec.size()-1;i+=2)
    {
	tru.push_back(vec[i+1]+vec[i]);
    }
    for(int i=0;i<tru.size();i++)
    {
        cout << tru[i] << endl;
    }
}
