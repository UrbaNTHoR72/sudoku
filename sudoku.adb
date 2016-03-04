with Ada.Text_IO; use Ada.Text_IO;
with ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with ada.strings.unbounded; use ada.strings.unbounded;
with ada.strings.unbounded.Text_IO; use ada.strings.unbounded.Text_IO;

--main procedure
-------------------------------------------------------
procedure Sudoku is
    type board is array (0..8,0..8) of integer;
    myGame : board;
    check : integer;
    debug : file_type;

    --LoadFile
    ---------------------------------------------------
    procedure LoadFile(game : out board) is
        infp : file_type;
        ch : character;
        fileName : unbounded_string;
    begin
    	put("Please enter the name of the input file> ");
    	get_line(fileName);
        open(infp,in_file,To_String(fileName));
            for i in 0..8 loop
                for j in 0..8 loop
                    get(infp,ch);
                    game(i,j) := Character'Pos(ch) - 48;
                end loop;
            end loop;
        close(infp);
    end LoadFile;

    --FindSolution
    ---------------------------------------------------
    procedure FindSolution(game : in out board; row, col : in integer; retVal : out integer) is 
    	check : integer;
    	--isValid
    	------------------------------------------------------------
    	function isValid(game : board; row,col,number : integer) return integer is
    		sectorRow : constant integer := 3 * (row/3);
    		sectorCol : constant integer := 3 * (col/3);
    		row1 : constant integer := (row + 2) rem 3;
    		row2 : constant integer := (row + 4) rem 3;
    		col1 : constant integer := (col + 2) rem 3;
    		col2 : constant integer := (col + 4) rem 3;
    	begin
    		for i in 0..8 loop
    			if game(i,col) = number then
    				return 0;
    			elsif game(row,i) = number then
    				return 0;
    			end if;
    		end loop;

    		if game(row1 + sectorRow,col1 + sectorCol) = number then
    			return 0;
    		elsif game(row2 + sectorRow,col1 + sectorCol) = number then
    			return 0;
    		elsif game(row1 + sectorRow,col2 + sectorCol) = number then
    			return 0;
    		elsif game(row2 + sectorRow,col2 + sectorCol) = number then
    			return 0;
    		end if;
    		return 1;
    	end isValid;
    begin
    	--if complete
    	if row = 9 then
    		retVal := 1;
    		return;
    	end if;

    	--if the space is already occupied
    	if game(row,col) /= 0 then
    		if col = 8 then
				FindSolution(game,row + 1, 0,check);
				if check = 1 then
					retVal := 1;
					return;
				end if;
			else
				FindSolution(game, row, col + 1, check);
				if check = 1 then
					retVal := 1;
					return;
				end if;
			end if;
			retVal := 0;
			return;
    	end if;

    	--random assignment loop
    	for next in 1..9 loop
    		if isValid(game,row,col,next) = 1 then
    			put("tried "); put(next); put (" at "); put (row + 1); put (col + 1); new_line;
    			game(row,col) := next;
    			if col = 8 then
 					FindSolution(game,row + 1, 0,check);
	 				if check = 1 then
	 					retVal := 1;
	 					return;
	 				end if;
 				else
 					FindSolution(game, row, col + 1, check);
 					if check = 1 then
 						retVal := 1;
 						return;
 					end if;
 				end if;
 				game(row,col) := 0;
    		end if;
    	end loop;
    end FindSolution;

    --WriteFile
    ---------------------------------------------------
    procedure WriteFile(game : in board) is
    outfp : file_type;
    fileName : unbounded_string;
    begin
    	--get output file name
    	put("please enter the name of the output file (leave blank for console)> ");
    	get_line(fileName);
    	if (fileName /= "") then
    		create(outfp, out_file, To_String(fileName));
    		set_output(outfp);
    	end if;

    	--display board
        put("+-----+-----+-----+");
        new_line;
        for k in 1..3 loop
	     	for i in (k*3 -2)..(k*3) loop
	        	put("|"); 
	        	for j in 1..3 loop
	        		put(game(i - 1,(j*3) - 3),width => 1);
	        		put(" "); 
	        		put(game(i - 1,(j*3) - 2),width => 1); 
	        		put(" "); 
	        		put(game(i - 1,(j*3) - 1),width => 1); 
	        		put("|");
	        	end loop;
	        	new_line;
	        end loop;
	        put("+-----+-----+-----+");
	        new_line;
	    end loop;

	    --return to normal
	    if is_open(outfp) then
			close(outfp);
		end if;
	    set_output(standard_output);
    end WriteFile;

    function isSolved(game : in board) return integer is
    begin
    	for i in 0..8 loop
    		for j in 0..8 loop
    			if game(i,j) = 0 then
    				return 0;
    			end if;
    		end loop;
    	end loop;
    	return 1;
    end isSolved;

begin
	--loads array from file
	LoadFile(game=> myGame);

	--prints out attempts made by recursive backtracking
	create(debug, out_file, "debug.txt");
	set_output(debug);
	--solves puzzle
    FindSolution(myGame,0,0,check);
    set_output(standard_output);
    delete(debug);

   	--checks if puzzle is solved and outputs the puzzle
   	if isSolved(game=> myGame) = 1 then
    	WriteFile(game => myGame);
    else
    	put("Puzzle is unsolvable");
    	new_line;
    end if;
end Sudoku;

