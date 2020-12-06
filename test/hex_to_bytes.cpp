#include <iostream>
#include <iostream>
#include <fstream>
using namespace std;

int main(int argc, char **argv){
    string textfile = argv[1];
    string testcaseid = argv[2];
    string filetype = ".bytes.txt";
    string bytefile = "./test/cases/"+testcaseid + filetype;
    string line;
    ifstream readfile(textfile);
    ofstream writefile (bytefile);
    if (readfile.is_open() && writefile.is_open()){
        while ( getline (readfile,line) ){
            if (line != ""){
                for (int i = line.length(); i > 0; i-=2){
                    writefile << line.substr(i-2, 2) << "\n"; 
                }
            }
        }
        readfile.close();
        writefile.close();
    } else {
        cout << "Unable to open file";
    }
    // ifstream new_readfile(bytefile);
    // if (new_readfile.is_open()){
    //     while ( getline (new_readfile,line) ){
    //         cout << line << '\n';
    //     }
    // }
    // new_readfile.close();
}