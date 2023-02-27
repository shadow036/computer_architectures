### Question 3
An 8 x 8 matrix XMATR of bytes stores ASCII CHARACTER “0” digits in its border cells and “1” to “9” ASCII CHARACTER digits in all the other internal cells. \
The matrix is cut by rows and implemented by the array XFIELD. Write an 8086 program which, having received an index k of XFIELD, computes a value in XRES DB ? as follows: \
    • If XFIELD[k] is a border cell (i.e. if XFIELD[k]=”0”), then the program returns the value 0 in XRES \
    • Otherwise, the program returns in XRES the sum of the corresponding values \
    of the cells which are its immediate diagonal (main and secondary, i.e. from left to right and from right to left) neighbors in XMATR; (the value of the cell should not be added).

### Question 4
Write the algoritm196 subroutine, which receives in input a 32-bit unsigned number M. If M (in the base-10 representation) is palindromic,
the function returns 0. A palindromic number is a number (such as 16461) that remains the same when its digits are reversed. \
If M is not palindromic, the function builds a new number N by reversing the digits of M. Then, the function returns M + N. \
Examples \
M = 126621. The function returns 0 \
M = 12661 -> N = 16621. The function returns 12661 + 16621 = 29282 \
You can obtain the digits of a number (from the least significant to the most significant) by repeatedly dividing by 10 and taking the remainder. For example: \
12661 / 10 = 1266 with remainder 1 \
1266 / 10 = 126 with remainder 6 \
126 / 10 = 12 with remainder 6 \
12 / 10 = 2 with remainder 2 \
1 / 10 = 0 with remainder 1 \
The loop ends when the result of the division is zero. \
Since you do not know how many digits the number has, it is suggested to save each digit in the stack. \
Then, you can access the stack to check if the number is palindromic. If the number is not palindromic, \
you can build N by repeatedly multiplying the temporary value of N by 10 and adding the next digit (starting from the least significant one). \
In the previous example:
    • first iteration: N = 0 * 10 + 1 = 1 \
    • second iteration: N = 1 * 10 + 6 = 16 \
    • third iteration: N = 16 * 10 + 6 = 166 \
    • fourth iteration: N = 166 * 10 + 2 = 1662 \
    • fifth iteration: N = 1662 * 10 + 1 = 16621 \
You can assume that the computation never generates an overflow.

### Question 5
Implement the handler for the supervisor call 100. \
The handler repeatedly calls the algoritm196 subroutine developed in the previous exercise, passing the value stored in r0. The loop ends when either one of the following conditions occur: \
    • the algoritm196 subroutine returns 0: it means that a palindromic number was reached. In this case, the handler sets r5 equal to 1 and ends. \
    • the algoritm196 subroutine has been called 10 times without returning 0. In this case, the initial value stored in r0 (when the handler was called) is a candidate to be a Lychrel number. \
    A Lychrel number is a natural number that cannot form a palindrome through the iterative process of repeatedly reversing its digits and adding the resulting numbers. \
    This process is called the 196-algorithm, because 196 is supposed to be the lowest Lychrel number. In this case, the handler sets r5 equal to 2 and ends. \
Examples \
If the supervisor call is called with r0 = 1879, the subsequent values of r0 are: 11660 -> 18271 -> 35552 -> 61105 -> 111221 -> 233332 -> 0 and the handler returns 1 (189 is not a Lychrel number). \
If the supervisor call is called with r0 = 196, the subsequent values of r0 are: 887 -> 1675 -> 7436 -> 13783 -> 52514 -> 94039 -> 187088 -> 1067869 -> 10755470 -> 18211171 and the handler returns 2 (196 is a Lychrel number). \
Note: within the handler, you can get the 16-bit operating code of the supervisor call by accessing the stack at position SP + 24 (you can assume that the calling program was using the main stack). The immediate value of the supervisor call is stored in the least significant byte.
