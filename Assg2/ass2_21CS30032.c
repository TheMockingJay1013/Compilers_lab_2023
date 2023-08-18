// Name: Navaneeth Shaji
// Roll no: 21CS30032


#include "myl.h"
#include <stdio.h>

int printStr(char *str)
{
    int i = 0;
    while (str[i] != '\0')           // obtaining the length of the string
    {
        i++;
    }
    __asm__ __volatile__(
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        : "S"(str), "d"(i));
    return i;
}

int readInt(int *n)
{
    char num[100] ;                                     // inputting the number into an array of char
    int len ,isneg=0;
    int i=0;

    long int number = 0;                                // the char array of num is converted to Int and stored in variable number


     __asm__ __volatile__ (
        "movl $0, %%eax \n\t"
        "movq $0, %%rdi \n\t"
        "syscall \n\t"
        :"=a"(len)
        :"S"(num), "d"(100)
    );


    // converting the array to int value

    if (len<=0)return ERR ;

    // if first symbol doesnt match any of the mentioned ones , ERR is returned
    if((num[0]!= '+') && (num[0]!='-') && ((num[0]<'0') || num[0]>'9')) return ERR ;

    // if the first symbol is '-' then we put isneg to 1 and convert the number to negative in the end
    if(num[0]=='-') {isneg =1;i=1;}

    // else the isneg is set to 0 
    else if(num[0]=='+'){isneg=0;i=1;}
    else i=0;
    
    // loop to go through all the array elements , as long a we find a ' ','\n' or other terminating symbols
    while ((num[i]!=' ') && (num[i] != '\n') && (num[i] != '\0') && (num[i]!='\t'))
    {
        if((num[i]<'0')||num[i]>'9')return ERR ;            // checking if the digit is a valid number
        number = 10.0*number + (num[i]-'0') ;               // if yes then convert the digit to int and append it to number
        i++;
    }

    // if number is negative , then negate the value in number
    if (isneg) number=-number;

    // store number is memory of n
    *n = number;
    return OK;
}

int printInt(int n)
{
    char num[100];                          // array to be populated with digits of the number 
    int i=0,j,k;

    if(n==0)num[i++]='0';                   // handling n==0 condition seperately
    else 
    {
        if(n<0)                             // if n is negative , we put a '-' at the start of the array and negate the value of the number
        {
            num[i++]='-';
            n=-n;
        }
        while(n)                            // taking the number digit by digit and storing in the array
        {   
            int dig = n%10;
            num[i++]=(char)(dig+'0');
            n/=10;
        }
        if(num[0]=='-' || num[0]=='+')j=1;
        else j=0;
        k=i-1;
        while(j<k)                          // since the order of digit in the array will be reverse , we will swap elements from the front and back
        {
            char temp = num[j];
            num[j++]=num[k];
            num[k--]=temp;
        }
    }   
    num[i]='\0';                            // adding a null character at the end so that printStr function can be used to print the array
    int s=printStr(num);                          // function call
    return s;                               // returning size of the array

}

int readFlt(float* f)
{
    char num[100];                              // array that will store the inputted float value
    int len ; int isneg=0; int i=0;             

    float number = 0;                          // the array elements will be converted to number and stored in the variable number

    __asm__ __volatile__ (
        "movl $0, %%eax \n\t"
        "movq $0, %%rdi \n\t"
        "syscall \n\t"
        :"=a"(len)
        :"S"(num), "d"(100)
    );

    // converting the array to float value
    if(len<=0)return ERR;

    // if first symbol doesnt match any of the mentioned ones , ERR is returned
    if((num[0]!='+') && (num[0]!='-') && (num[0]<'0'|| num[0]>'9')) return ERR;

    // if the first symbol is '-' then we put isneg to 1 and convert the number to negative in the end
    if(num[0]=='-'){isneg=1;i=1;}

    // else isneg is set to 0
    else if(num[0]=='+'){isneg=0;i=1;}
    else i=0;

    // isdec will denote if the decimal point has been used in the inputted number 
    // div will denote the factor by which the inputted fractional digit contributed to the number
    int isdec = 0; int div=10;


    // loop to go through the all the array elememts , as long as one of the following terminating characters is found
    while((num[i]!=' ') && (num[i] != '\n') && (num[i] != '\0'))
    {
        if(num[i]=='.' && isdec==0){isdec=1;i++;continue;}              // handling the '.' case first and setting isdec accordingly
        if(!isdec)                                                      // handling the integral part like in readInt
        {
            if((num[i]<'0')||num[i]>'9')return ERR ;           
            number = 10.0*number + (num[i]-'0') ;
            i++;
        }
        else                                                            // handling the fractional part
        {
            float val = 1.0*((int)(num[i]-'0'))/div;
            number+=val;
            div = 10*div;
            i++;
        }
        
        
    }
    if (isneg)number=-number;                                               // if number is negative , then negate the value in number
    *f = number ;                                                     // store number in memory of f
    return OK;
}

int printFlt(float f)
{
    char num[100];                                                          // array to be populated with digits of the number
    int i=0; int j,k;

    if(f<0)                                                                // if f is negative , we put a '-' at the start of the array and negate the value of the number      
    {
        num[i++]='-';
        f=-f;
    }   
    long long int whole = (long int)f;                                                 // getting the interger part of the float number
    long long int frac = (long int)((f-whole)*100000000);      //getting fractional values upto 6 decimal places .


    j=i;
    if (whole == 0)                                         // if whole part is 0 , we put a '0' at the start of the array
    {
        num[i++]='0';
    }
    else 
    {
        while(whole>0)                                      // taking the number digit by digit and storing in the array
        {
            int digit = whole%10;
            num[i++]=(char)(digit + '0');
            whole/=10;
        }

        k = i-1 ;
        while(j<k)                                                      // since the order of digit in the array will be reverse , we will swap elements from the front and back
        {
            char temp = num[j];
            num[j++]=num[k];
            num[k--]=temp;
        }

    }

    // end of the integral part 
    // handling the fractional part now 

    num[i++]='.';                                   // adding a '.' to the array

    j=i;
    while(frac>0)                                   // taking the number digit by digit and storing in the array
    {
        int digit = frac%10;
        num[i++]=(char)(digit+'0') ;
        frac/=10;
    }

    k=i-1;
    while(j<k)                                      // since the order of digit in the array will be reverse , we will swap elements from the front and back
    {
        char temp = num[j];
        num[j++]=num[k];
        num[k--]=temp;
    }

    num[i]='\0';                                    // adding a null character at the end so that printStr function can be used to print the array
    int size = printStr(num);                       // function call
    return size ;                                   // returning size of the array
}

// int main()
// {
//     float f ;
//     readFlt(&f);
//     printFlt(f);
//     return 0;
// }