(*
 * File: FIOManageFn_Cyclic.st
 * Copyright (c) 2023 Loupe
 * https://loupe.team
 * 
 * This file is part of FIOWrap, licensed under the MIT License.
 * 
  ********************************************************************
 * Implementation of library FIOWrap
 ********************************************************************) 


(********************************************************************)
(* This function manages multiple files for logs					*)
(********************************************************************)


(* Resetting internal CMDs				DONE and NOT TESTED *)


(* Main State machine					DONE NOT TESTED *)

	(* ST_WAIT							DONE NOT TESTED *)
		(* Wait for new CMDs			DONE and TESTED *)
			(* Scan						DONE and TESTED  *)
				(* Set CurrOperation	DONE and TESTED  *)
				(* Busy, Done			DONE and TESTED  *)
				(* Change state			DONE and TESTED  *)
			(* DeleteAll				DONE and NOT TESTED  *)
				(* Set CurrOperation	DONE and TESTED  *)
				(* Busy, Done			DONE and TESTED  *)
				(* Change state			DONE and TESTED  *)
		(* Reset Done					DONE and TESTED  *)

	(* ST_OPEN							DONE and NOT TESTED  *)
		(* FUB inputs					DONE and TESTED  *)
		(* Status checking				DONE and TESTED  *)
			(* Done						DONE and TESTED  *)
			(* No error					DONE and TESTED  *)
				(* Open					DONE and TESTED  *)
			(* Other error				DONE and NOT TESTED  *)

	(* ST_READ							DONE and NOT TESTED  *)
		(* FUB inputs					DONE and NOT TESTED  *)
		(* Status checking				DONE and NOT TESTED  *)
			(* Done						DONE and TESTED  *)
			(* No error					DONE and TESTED  *)
			(* Error					DONE and TESTED  *)
				
	(* ST_CLOSE							DONE and NOT TESTED  *)
		(* FUB inputs					DONE and NOT TESTED  *)
		(* Status checking				DONE and NOT TESTED  *)
			(* Done						DONE and TESTED  *)
			(* No error					DONE and TESTED  *)
				(* ErrorClose			DONE and NOT TESTED  *)
			(* Error					DONE will not be tested *)
			
	(* ST_DELETE						DONE and NOT TESTED  *)
		(* FUB inputs					DONE and NOT TESTED  *)
		(* Status checking				DONE and NOT TESTED  *)
			(* Done						DONE and TESTED  *)
			(* No error					DONE and TESTED  *)
			(* File not found			DONE and NOT TESTED  *)
			(* Other error				DONE and NOT TESTED  *)
			
	(* ST_ERROR							DONE and TESTED  *)
		(* Disable FUBs					DONE and TESTED  *)
		(* AcknowledgeError CMD			DONE and TESTED  *)
		

(* Busy, Done, Error					DONE and TESTED  *)
				

FUNCTION FIOManageFn_Cyclic
	

(************************************************************************)
(* Set return value to get rid of compiler warning 						*)
(************************************************************************)

FIOManageFn_Cyclic:=	FALSE;


(************************************************************************)
(* Reset internal CMDs													*)
(************************************************************************)

IF( NOT(t.IN.CMD.Scan) )THEN

	t.Internal.CMD.Scan:=	0;
	
END_IF

IF( NOT(t.IN.CMD.DeleteAll) )THEN

	t.Internal.CMD.DeleteAll:=	0;
	
END_IF


(************************************************************************)
(* Main state machine													*)
(************************************************************************)

	CASE t.Internal.State OF


		FIOWRAP_ST_WAIT:
	
	
			(* If all CMDs are cleared, then clear Done status *)
	
			IF( 	NOT(t.IN.CMD.Scan)
				AND	NOT(t.IN.CMD.DeleteAll)
				)THEN
   
				t.OUT.STAT.Done:=	0;
			
			END_IF
		
			(* Set CurrOperation to INVALID. It will be set below on leaving the state *)
		
			t.Internal.CurrOperation:=	FIOWRAP_OP_INVALID;
		
			(* Wait for new commands *)
		
			IF( t.IN.CMD.Scan AND NOT(t.Internal.CMD.Scan) )THEN
			
				t.Internal.CMD.Scan:=	1;
			
				t.OUT.STAT.Busy:=	1;
				t.OUT.STAT.Done:=	0;
						
				t.Internal.State:=			FIOWRAP_ST_OPEN;
				t.Internal.CurrOperation:=	FIOWRAP_OP_SCAN;
				
				// Modify filter based off of input itemName
				IF(t.IN.PAR.ItemName = '') THEN
					// Set error for filter input
					fiomSetError( DINT_TO_UINT(FIOWRAP_ERR_INVALIDFILTER), t );
				ELSIF (t.IN.PAR.ItemName = '*') THEN
					t.Internal.FilterName := '';
				ELSE
					t.Internal.FilterName := t.IN.PAR.ItemName;
				END_IF
			
			
			ELSIF( t.IN.CMD.DeleteAll AND NOT(t.Internal.CMD.DeleteAll) )THEN

				// TODO: Delete All should not open file more than once
			
				t.Internal.CMD.DeleteAll:=	1;
			
				t.OUT.STAT.Busy:=	1;
				t.OUT.STAT.Done:=	0;
						
				t.Internal.State:=			FIOWRAP_ST_OPEN;
				t.Internal.CurrOperation:=	FIOWRAP_OP_DELETE_ALL;

			
			END_IF
	
	
		FIOWRAP_ST_OPEN:
	
		
			(* Open Dir *)
		
			t.Internal.FUB.DirOpen.enable:=	1;
			t.Internal.FUB.DirOpen.pDevice:=	ADR(t.IN.PAR.FileDevice);
			IF( brsstrlen(ADR(t.IN.PAR.Directory)) = 0 )THEN
				t.Internal.FUB.DirOpen.pName:= 0;
				// Scanning/deleting is not allowed while in a root directory
				// TODO: figure out how to throw an error because figuring out if you are in a root directory is difficult
			ELSE
				t.Internal.FUB.DirOpen.pName:=		ADR(t.IN.PAR.Directory);
			END_IF
		
		
			(* Check status *)
				
			IF( t.Internal.FUB.DirOpen.status < FIOWRAP_STAT_DISABLED ) THEN
  			
			
				(* Turn off FUB *)
			
				t.Internal.FUB.DirOpen.enable:=	0;

  
				IF( t.Internal.FUB.DirOpen.status = FIOWRAP_STAT_OK ) THEN
   				
			
				(* All good
					Get Ident, go to appropriate state *)
				
					t.Internal.DirID:=		t.Internal.FUB.DirOpen.ident;
				
					IF( t.Internal.CurrOperation = FIOWRAP_OP_DELETE
						OR t.Internal.CurrOperation = FIOWRAP_OP_DELETE_ALL
						OR t.Internal.CurrOperation = FIOWRAP_OP_SCAN)THEN
						
						t.Internal.State:= FIOWRAP_ST_READ;
						
					ELSE
					
						fiomSetError( DINT_TO_UINT(FIOWRAP_ERR_INVALIDOP), t );
						
					END_IF
						
				
				ELSE
				
			
					(* Other error *)
				
					fiomSetError( t.Internal.FUB.DirOpen.status, t );

				
				END_IF (* If error *)
			
		END_IF (* If done *)
	
		
		FIOWRAP_ST_READ:
			
			(* Check status *)
			
			IF( t.Internal.FUB.DirRead.status < FIOWRAP_STAT_DISABLED )THEN
				
				(* Turn off FUB *)
				
				t.Internal.FUB.DirRead.enable:= 0;
				 
				IF ( t.Internal.FUB.DirRead.status = FIOWRAP_STAT_OK ) THEN	
					
					(* Turn on FUB *)
					t.Internal.FUB.DirRead.enable:= 1;
					
					// Check mode and file type before adding to the cache
					IF( (t.IN.PAR.Mode = fiFILE AND t.Internal.ItemInfo.Mode = fiFILE)
						OR (t.IN.PAR.Mode = fiDIRECTORY AND t.Internal.ItemInfo.Mode = fiDIRECTORY)
						OR (t.IN.PAR.Mode = fiBOTH) )THEN 
						
						(* Get File Names and Extensions *)
						SplitFileName(ADR(t.Internal.FilterName),ADR(t.Internal.Name), ADR(t.Internal.Extension));
						SplitFileName(ADR(t.Internal.ItemInfo.Filename),0,ADR(t.Internal.FileExtension));
						brsmemcpy(ADR(t.Internal.ItemName),ADR(t.Internal.ItemInfo.Filename),brsstrlen(ADR(t.Internal.Name)));
						
						// Check to see if the file/directory name and extension (if specified) match and that the directory is not '.' or '..'
						IF( (brsstrcmp(ADR(t.Internal.ItemName),ADR(t.Internal.Name)) = 0) 
							AND ((brsstrcmp(ADR(t.Internal.FileExtension),ADR(t.Internal.Extension)) = 0) OR (brsstrcmp(ADR(t.Internal.Extension),ADR('')) = 0))
							AND NOT ((brsstrcmp(ADR(t.Internal.ItemInfo.Filename),ADR('.')) = 0) OR (brsstrcmp(ADR(t.Internal.ItemInfo.Filename),ADR('..')) = 0) ))THEN
							// increment number of files
							t.Internal.NumItems:= t.Internal.NumItems+1;
							
							// All indices in the cache are set to very large dates initially
							IF( t.Internal.ItemInfoCache[t.Internal.NewestIndex].Date > t.Internal.ItemInfo.Date )THEN
								
								(* Record Older file info *)
								brsmemcpy(ADR(t.Internal.ItemInfoCache[t.Internal.NewestIndex]),ADR(t.Internal.ItemInfo),SIZEOF(t.Internal.ItemInfo));
								
								(* Find Oldest / Newest file *)
								FOR t.Internal.index := 0 TO FIOWRAP_MAI_DELETE DO
									IF t.Internal.ItemInfoCache[t.Internal.OldestIndex].Date > t.Internal.ItemInfoCache[t.Internal.index].Date THEN
										t.Internal.OldestIndex := t.Internal.index;
									END_IF
									IF  t.Internal.ItemInfoCache[t.Internal.NewestIndex].Date < t.Internal.ItemInfoCache[t.Internal.index].Date THEN
										t.Internal.NewestIndex := t.Internal.index;
									END_IF
								END_FOR;
							END_IF
							
							// Start deleting files if you have the max number of files you can delete in one read.
							IF( t.Internal.NumItems >=  FIOWRAP_NUM_DELETE
								AND t.Internal.CurrOperation = FIOWRAP_OP_DELETE_ALL )THEN
								
								t.Internal.FUB.DirRead.enable:= 0;
								
								t.Internal.NumItemsDelete:= FIOWRAP_NUM_DELETE;
								
								(* Delete files *)
					
								t.Internal.State := FIOWRAP_ST_DELETE;
								
							END_IF
						
						END_IF

					END_IF
					
				ELSIF ( t.Internal.FUB.DirRead.status = fiERR_NO_MORE_ENTRIES ) THEN

					IF t.Internal.CurrOperation = FIOWRAP_OP_DELETE_ALL THEN 
						
						(* Delete Files *)
						
						t.Internal.NumItemsDelete:= MIN(t.Internal.NumItems, FIOWRAP_NUM_DELETE);
						
						IF t.Internal.NumItemsDelete > 0 THEN
							t.Internal.CurrOperation := FIOWRAP_OP_DELETE;
						ELSE
							t.Internal.CurrOperation := FIOWRAP_OP_SCAN; //TODO: Change this to valid op
						END_IF
						
					ELSIF t.Internal.NumItems > t.IN.PAR.MaxNumItems THEN	
						
						(* Delete Files *)
						
						t.Internal.NumItemsDelete:= MIN(t.Internal.NumItems - t.IN.PAR.MaxNumItems, FIOWRAP_NUM_DELETE);
						
						t.Internal.CurrOperation := FIOWRAP_OP_DELETE;
						
					END_IF
					
					
					IF( t.Internal.CurrOperation = FIOWRAP_OP_DELETE
						OR t.Internal.CurrOperation = FIOWRAP_OP_DELETE_ALL
						OR t.Internal.CurrOperation = FIOWRAP_OP_SCAN )THEN
						
						(* Close Dir *)
					
						t.Internal.State := FIOWRAP_ST_CLOSE;
					
					ELSE
					
						fiomSetError( DINT_TO_UINT(FIOWRAP_ERR_INVALIDOP), t );
						
					END_IF				

				
				ELSE
					
					(* Error *)
					
					t.Internal.ErrorClose:= 1;
					
					IF( t.Internal.FUB.DirRead.status = 20799 )THEN
					
						//If the sysError ID = 65535 then we are in a root directory and can't do a read
						t.OUT.STAT.ErrorID := FileIoGetSysError();
						IF (t.OUT.STAT.ErrorID = 65535) THEN
							fiomSetError( DINT_TO_UINT(FIOWRAP_ERR_INVALIDDIR), t );
						ELSE
							fiomSetError( t.OUT.STAT.ErrorID, t );
						END_IF

					ELSE
						
						fiomSetError( t.Internal.FUB.DirRead.status, t );
						
					END_IF
					
					t.Internal.State:= FIOWRAP_ST_CLOSE;
				
				END_IF
				
			ELSIF( t.Internal.FUB.DirRead.status = FIOWRAP_STAT_DISABLED )THEN
				
				(* Enable FUB *)
				t.Internal.FUB.DirRead.enable 	:= 1;
				t.Internal.FUB.DirRead.ident	:= t.Internal.DirID;
				t.Internal.FUB.DirRead.pData	:= ADR(t.Internal.ItemInfo);
				t.Internal.FUB.DirRead.data_len	:= SIZEOF(t.Internal.ItemInfo);

				t.Internal.NumItems := 0;
				t.Internal.NumItemsDelete:= 0;
				t.Internal.OldestIndex := 0;
				t.Internal.NewestIndex := 0;
				brsmemset(ADR(t.Internal.ItemName), 0, SIZEOF(t.Internal.ItemName));
				
				
				brsmemset(ADR(t.Internal.ItemInfoCache), 0, SIZEOF(t.Internal.ItemInfoCache));
				FOR t.Internal.index := 0 TO FIOWRAP_MAI_DELETE DO
					t.Internal.ItemInfoCache[t.Internal.index].Date := DT#2106-02-06-06:28:15; // Can this be a hex value instead?	
				END_FOR
				
				
			END_IF
		
			
		FIOWRAP_ST_CLOSE:
	
		
			(* Close file *)
		
			t.Internal.FUB.DirClose.enable:=	1;
			t.Internal.FUB.DirClose.ident:=	t.Internal.DirID;
		
		
			(* Check status *)
		
			IF( t.Internal.FUB.DirClose.status < FIOWRAP_STAT_DISABLED ) THEN
  			
			
				(* Turn off FUB *)
			
				t.Internal.FUB.DirClose.enable:=	0;
  

				IF( t.Internal.FUB.DirClose.status = FIOWRAP_STAT_OK ) THEN
   				
			
					IF( t.Internal.ErrorClose ) THEN
					
					
						(* If error, go to error state *)	
	
						t.Internal.State:=	FIOWRAP_ST_ERROR;
						
						t.Internal.ErrorClose:= 0;
					
					ELSIF( (t.Internal.CurrOperation = FIOWRAP_OP_DELETE 
						OR t.Internal.CurrOperation = FIOWRAP_OP_DELETE_ALL) 
						AND t.Internal.NumItemsDelete > 0) THEN
						
						t.Internal.State:=	FIOWRAP_ST_DELETE;
						
					ELSE
					
						(* otherwise, done, set status and go to wait state *)	
					
						t.OUT.STAT.Busy:=	0;
						t.OUT.STAT.Done:=	1;
						
						t.Internal.State:=	FIOWRAP_ST_WAIT;
					
					END_IF (* If ErrorClose *)
				
				
				ELSE
			  	
				
					(* Error *)
				
					fiomSetError( t.Internal.FUB.DirClose.status, t );
				
				
				END_IF (* If error *)
			
		END_IF (*If done *)
		
		FIOWRAP_ST_DELETE:
			
			IF( t.Internal.NumItemsDelete > 0 )THEN
		
				(* Generate file name *)
		
				brsmemcpy(ADR(t.Internal.ItemName),ADR(t.Internal.ItemInfoCache[t.Internal.OldestIndex].Filename),SIZEOF(t.Internal.ItemName));
				t.Internal.ItemName := CONCAT(CONCAT(t.IN.PAR.Directory, '/'), t.Internal.ItemName);
		
				// Check file type and go to appropriate state
				IF(t.Internal.ItemInfoCache[t.Internal.OldestIndex].Mode = fiFILE) THEN
					t.Internal.State := FIOWRAP_ST_DELETE_FILE;
				ELSE
					t.Internal.State := FIOWRAP_ST_DELETE_DIR;
				END_IF
				
				(* Remove Old file from list *)
				
				t.Internal.ItemInfoCache[t.Internal.OldestIndex].Date := DT#2106-02-06-06:28:15; // Can this be a hex value instead?

				(* Find new oldest / newest file *)
				
				FOR t.Internal.index := 0 TO FIOWRAP_MAI_DELETE DO
					IF t.Internal.ItemInfoCache[t.Internal.OldestIndex].Date > t.Internal.ItemInfoCache[t.Internal.index].Date THEN
						t.Internal.OldestIndex := t.Internal.index;
					END_IF
					IF  t.Internal.ItemInfoCache[t.Internal.NewestIndex].Date < t.Internal.ItemInfoCache[t.Internal.index].Date THEN
						t.Internal.NewestIndex := t.Internal.index;
					END_IF
				END_FOR;
				
			ELSIF( t.Internal.NumItemsDelete <= 0 )THEN
					
				IF( t.Internal.CurrOperation = FIOWRAP_OP_DELETE_ALL )THEN
						
					(* Go to Read *)
					// Find more files to delete
					t.Internal.State:= FIOWRAP_ST_OPEN;
						
				ELSIF( t.Internal.CurrOperation = FIOWRAP_OP_DELETE )THEN
					
					(* Done, set status and go to wait state *)	
					t.OUT.STAT.Busy:=	0;
					t.OUT.STAT.Done:=	1;
					
					t.Internal.State:=	FIOWRAP_ST_WAIT;
						
				ELSE 
					// Set the error	
					fiomSetError( DINT_TO_UINT(FIOWRAP_ERR_INVALIDOP), t );
						
				END_IF
			
			END_IF
			
		FIOWRAP_ST_DELETE_FILE:
			(* Enable FUB *)
			IF (NOT t.Internal.FUB.Delete.enable) THEN
				t.Internal.FUB.Delete.enable := 1;
				t.Internal.FUB.Delete.pDevice := ADR(t.IN.PAR.FileDevice);
				t.Internal.FUB.Delete.pName := ADR(t.Internal.ItemName);
			END_IF
			
			(*Delete File*)
			IF( t.Internal.FUB.Delete.status < FIOWRAP_STAT_DISABLED )THEN
				
				(* Turn off FUB *)
				t.Internal.FUB.Delete.enable:= 0;
			
				IF( t.Internal.FUB.Delete.status = FIOWRAP_STAT_OK )THEN
				
					t.Internal.NumItems := t.Internal.NumItems - 1;
					t.Internal.NumItemsDelete := t.Internal.NumItemsDelete - 1;
					
					// Return to delete state
					t.Internal.State := FIOWRAP_ST_DELETE;
					
				ELSE
				
					(* error *)
					
					//TODO: Handle file not found error 
				
					fiomSetError( t.Internal.FUB.Delete.status, t );
				
				END_IF
			END_IF
			
		FIOWRAP_ST_DELETE_DIR:
			(* Enable FUB *)
			IF (NOT t.Internal.FUB.DeleteDir.enable) THEN
				t.Internal.FUB.DeleteDir.enable := 1;
				t.Internal.FUB.DeleteDir.pDevice := ADR(t.IN.PAR.FileDevice);
				t.Internal.FUB.DeleteDir.pName := ADR(t.Internal.ItemName);
			END_IF

			(*Delete File*)
		
			IF( t.Internal.FUB.DeleteDir.status < FIOWRAP_STAT_DISABLED )THEN
				
				(* Turn off FUB *)
			
				t.Internal.FUB.DeleteDir.enable:= 0;
			
				IF( t.Internal.FUB.DeleteDir.status = FIOWRAP_STAT_OK )THEN
				
					t.Internal.NumItems := t.Internal.NumItems - 1;
					t.Internal.NumItemsDelete := t.Internal.NumItemsDelete - 1;
					
					// Return to delete state
					t.Internal.State := FIOWRAP_ST_DELETE;
					
				ELSE
				
					(* error *)
					
					//TODO: Handle file not found error 
				
					fiomSetError( t.Internal.FUB.DeleteDir.status, t );
				
				END_IF
			END_IF

		
		FIOWRAP_ST_ERROR:
		
			(* Turn off all FUBs, just in case *)
		
			t.Internal.FUB.DirOpen.enable:=	0;
			t.Internal.FUB.DirRead.enable:=	0;
			t.Internal.FUB.DirClose.enable:=	0;
			t.Internal.FUB.Delete.enable:=	0;
	
	
			IF( t.IN.CMD.AcknowledgeError )THEN
			
				t.OUT.STAT.Error:=			0;
				t.OUT.STAT.ErrorID:=		0;
				t.OUT.STAT.ErrorString:=	'';
				t.OUT.STAT.ErrorLevel:=		0;
				t.Internal.State:=			FIOWRAP_ST_WAIT;
			
			END_IF 
		
	
	END_CASE


	(* Reset AcknowledgeError CMD *)

	t.IN.CMD.AcknowledgeError:=	0;
			

	(****************************************)
	(* Call FUBs							*)
	(****************************************)

	t.Internal.FUB.DirOpen();
	t.Internal.FUB.DirRead();
	t.Internal.FUB.DirClose();
	t.Internal.FUB.Delete();
	t.Internal.FUB.DeleteDir();


(****************************************)
(* Set ReadyForCMD						*)
(****************************************)

t.OUT.STAT.ReadyForCMD:=		NOT(t.OUT.STAT.Busy)
							AND NOT(t.OUT.STAT.Done)
							AND	NOT(t.OUT.STAT.Error);


END_FUNCTION
