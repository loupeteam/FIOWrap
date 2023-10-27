(*
 * File: fioOpenFile_Init.st
 * Copyright (c) 2023 Loupe
 * https://loupe.team
 * 
 * This file is part of FIOWrap, licensed under the MIT License.
 * 
  *******************************************************************)
//-------------------------------------------------------------------
// Open a file in the init subroutine
//-------------------------------------------------------------------

FUNCTION fioOpenFile_Init

	// Open a file - tested
	WHILE (TRUE) DO

		t.IN.CMD.Open := TRUE;
		
		FIOWrapFn_Cyclic(t);
	
		IF (t.OUT.STAT.Done OR t.OUT.STAT.Error) THEN
			t.IN.CMD.Open := FALSE;
			FIOWrapFn_Cyclic(t);
			fioOpenFile_Init := t.OUT.STAT.ErrorID;
			RETURN;
		END_IF
		
	END_WHILE

END_FUNCTION
