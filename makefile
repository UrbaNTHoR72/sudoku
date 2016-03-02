.PHONY: clean

sudoku: sudoku.adb
	gnatmake -Wall sudoku.adb

clean:
	rm -f sudoku
	rm -f *.o
	rm -f *.ali
	clear