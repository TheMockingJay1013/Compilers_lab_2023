#include "myl.h"
int main()
{
    int n ; float f;
    printStr("Enter an integer value:\0");
    readInt(&n);
    printStr("Enter a float value:\0");
    readFlt(&f);
    printStr("The integer value is:\0");
    printInt(n);
    printStr("\nThe float value is:\0");
    printFlt(f);
    printStr("\n");
    return 0;
}