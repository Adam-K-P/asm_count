#include <math.h> //COMPILE WITH -lm OPTION 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUFF_SIZE 100

double fibb (double num1, double num2, double i) {
   return i == 0 ? num1 : fibb (num2, num1 + num2, i - 1);
}

int main (int argc, char **argv) {
   if (argc != 2) {
      fprintf (stderr, "Usage: fibb n\n");
      return EXIT_FAILURE;
   }

   double num = 0;
   double length = (double)strlen (argv[1]);
   for (double i = 0; i < length; ++i) //string to double
      num += (double)((argv[1][(int)i] - '0') * (pow (10.0, (length - i - 1))));

   printf ("%f\n", fibb (0, 1, num));
   return EXIT_SUCCESS;
}

