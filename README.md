Sudoku.adb
/********************************
author: ethan gagne
email: ethan@ethangagne.com

resources: https://spin.atomicobject.com/2012/06/18/solving-sudoku-in-c-with-recursive-backtracking/


notes:-currently being debugged (requires an unneccesary print statement to work)
      -has no error checking
      -filenames must include the extention and are taken from the local directory
**********************************/

solves sudoku puzzles read in from a file with zeros being blanks.
ex:
005300000
800000020
070010500
400005300
010070006
003200080
060500009
004000030
000009700

it is solved using a brute force recursive backtracking algorithm that transfered from c into ada from the resource listed in the header.

the solved puzzle will be output to a file of the user's choosing or the terminal if nothing is entered.
