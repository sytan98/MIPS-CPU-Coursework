#include "assembler.h"
#include <iostream>
#include <string>
#include <cstring>
#include <fstream>
#include <cstdlib>
#include <cctype>
#include <vector>

using namespace std;

int main(int argc, char **argv)
{   
    string option = "text";
    if (argc>1){
        option = argv[1];
    }
    openFile();
    cout << "file open and parsed..." << endl;
    compareTokens();
    cout << "Tokens Compared..." << endl;
    printSymbols();
    cout << "Symbols Printed..." << endl;
    if (option == "MIF"){
        printMIF();
    } else if (option=="text") {
        printText();
    }
    
    cout << "Assembled file created..." << endl;
    return 0;
}