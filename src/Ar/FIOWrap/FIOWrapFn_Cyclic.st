(*
 * File: FIOWrapFn_Cyclic.st
 * Copyright (c) 2023 Loupe
 * https://loupe.team
 * 
 * This file is part of FIOWrap, licensed under the MIT License.
 * 
 ********************************************************************
 * Implementation of library FIOWrap
 ********************************************************************) 


(********************************************************************)
(* This function manages simple file reads and writes				*)
(********************************************************************)


(* Resetting internal CMDs				DONE and TESTED DFB 20110602 *)


(* Main State machine					DONE and TESTED DFB 20110602 *)

	(* ST_WAIT							DONE and TESTED DFB 20110602 *)
		(* Wait for new CMDs			DONE and TESTED DFB 20110602 *)
			(* SaveAs					DONE and TESTED DFB 20110602 *)
				(* Set CurrOperation	DONE and TESTED DFB 20110602 *)
				(* Busy, Done			DONE and TESTED DFB 20110602 *)
				(* Change state			DONE and TESTED DFB 20110602 *)
			(* Open						DONE and TESTED DFB 20110602 *)
				(* Set CurrOperation	DONE and TESTED DFB 20110602 *)
				(* Busy, Done			DONE and TESTED DFB 20110602 *)
				(* Change state			DONE and TESTED DFB 20110602 *)
			(* AppendToFile				DONE and TESTED DFB 20110602 *)
				(* Set CurrOperation	DONE and TESTED DFB 20110602 *)
				(* Busy, Done			DONE and TESTED DFB 20110602 *)
				(* Change state			DONE and TESTED DFB 20110602 *)
			(* Delete					DONE and TESTED DFB 20110602 *)
				(* Set CurrOperation	DONE and TESTED DFB 20110602 *)
				(* Busy, Done			DONE and TESTED DFB 20110602 *)
				(* Change state			DONE and TESTED DFB 20110602 *)
		(* Reset Done					DONE and TESTED DFB 20110602 *)

	(* ST_OPEN							DONE and TESTED DFB 20110602 *)
		(* FUB inputs					DONE and TESTED DFB 20120131 *)
		(* Status checking				DONE and TESTED DFB 20110602 *)
			(* Done						DONE and TESTED DFB 20110602 *)
			(* No error					DONE and TESTED DFB 20110602 *)
				(* Open					DONE and TESTED DFB 20110602 *)
				(* SaveAs				DONE and TESTED DFB 20110602 *)
				(* AppendToFile			DONE and TESTED DFB 20110602 *)
			(* File not found			DONE and TESTED DFB 20111222 *)
				(* Open					DONE and TESTED DFB 20111222 *)
				(* SaveAs				DONE and TESTED DFB 20111222 *)
				(* AppendToFile			DONE and TESTED DFB 20111222 *)
			(* Other error				DONE and TESTED DFB 20111222 *)
				
	(* ST_CREATE						DONE and TESTED DFB 20110602 *)
		(* FUB inputs					DONE and TESTED DFB 20120131 *)
		(* Status checking				DONE and TESTED DFB 20110602 *)
			(* Done						DONE and TESTED DFB 20110602 *)
			(* No error					DONE and TESTED DFB 20110602 *)
				(* SaveAs				DONE and TESTED DFB 20110602 *)
				(* AppendToFile			DONE and TESTED DFB 20110602 *)
			(* Error					DONE will not be tested *)

	(* ST_READ							DONE and TESTED DFB 20110602 *)
		(* FUB inputs					DONE and TESTED DFB 20120131 *)
		(* Status checking				DONE and TESTED DFB 20110602 *)
			(* Done						DONE and TESTED DFB 20110602 *)
			(* No error					DONE and TESTED DFB 20110602 *)
			(* Error					DONE and TESTED DFB 20111222 *)
				
	(* ST_WRITE							DONE and TESTED DFB 20110602 *)
		(* FUB inputs					DONE and TESTED DFB 20120131 *)
			(* SaveAs					DONE and TESTED DFB 20120131 *)
			(* AppendToFile				DONE and TESTED DFB 20120131 *)
				(* No error				DONE and TESTED DFB 20120131 *)
				(* MaxFileSize error	DONE and TESTED DFB 20120131 *)
		(* Status checking				DONE and TESTED DFB 20110602 *)
			(* Done						DONE and TESTED DFB 20110602 *)
			(* No error					DONE and TESTED DFB 20110602 *)
			(* Error					DONE and TESTED DFB 20111222 *)
				
	(* ST_CLOSE							DONE and TESTED DFB 20110602 *)
		(* FUB inputs					DONE and TESTED DFB 20120131 *)
		(* Status checking				DONE and TESTED DFB 20110602 *)
			(* Done						DONE and TESTED DFB 20110602 *)
			(* No error					DONE and TESTED DFB 20110602 *)
				(* ErrorClose			DONE and TESTED DFB 20110602 *)
			(* Error					DONE will not be tested *)
			
	(* ST_DELETE						DONE and TESTED DFB 20110602 *)
		(* FUB inputs					DONE and TESTED DFB 20120131 *)
		(* Status checking				DONE and TESTED DFB 20110602 *)
			(* Done						DONE and TESTED DFB 20110602 *)
			(* No error					DONE and TESTED DFB 20111222 *)
			(* File not found			DONE and TESTED DFB 20111222 *)
			(* Other error				DONE and TESTED DFB 20111222 *)
			
	(* ST_ERROR							DONE and TESTED DFB 20110602 *)
		(* Disable FUBs					DONE and TESTED DFB 20110602 *)
		(* AcknowledgeError CMD			DONE and TESTED DFB 20111222 *)
		

(* Busy, Done, Error					DONE and TESTED DFB 20111222 *)
				

FUNCTION FIOWrapFn_Cyclic
	

(************************************************************************)
(* Set return value to get rid of compiler warning 						*)
(************************************************************************)

	FIOWrapFn_Cyclic:=	FALSE;


	(************************************************************************)
	(* Reset internal CMDs													*)
	(************************************************************************)

	IF( NOT(t.IN.CMD.Open) )THEN

		t.Internal.CMD.Open:=	0;
	
	END_IF


	IF( NOT(t.IN.CMD.SaveAs) )THEN

		t.Internal.CMD.SaveAs:=	0;
	
	END_IF


	IF( NOT(t.IN.CMD.AppendToFile) )THEN

		t.Internal.CMD.AppendToFile:=	0;
	
	END_IF


	IF( NOT(t.IN.CMD.Delete) )THEN

		t.Internal.CMD.Delete:=	0;
	
	END_IF


	(************************************************************************)
	(* Main state machine													*)
	(************************************************************************)

	CASE t.Internal.State OF


		FIOWRAP_ST_WAIT:
	
	
			(* If all CMDs are cleared, then clear Done status *)
	
			IF( 	NOT(t.IN.CMD.Open)
				AND	NOT(t.IN.CMD.SaveAs)
				AND	NOT(t.IN.CMD.AppendToFile)
				AND	NOT(t.IN.CMD.Delete)
				)THEN
   
				t.OUT.STAT.Done:=	0;
			
			END_IF
		
		
			(* Set CurrOperation to INVALID. It will be set below on leaving the state *)
		
			t.Internal.CurrOperation:=	FIOWRAP_OP_INVALID;
		
		
			(* Wait for new commands *)
		
			IF( t.IN.CMD.SaveAs AND NOT(t.Internal.CMD.SaveAs) )THEN
			

				t.Internal.CMD.SaveAs:=	1;
			
				t.OUT.STAT.Busy:=	1;
				t.OUT.STAT.Done:=	0;
						
				t.Internal.State:=			FIOWRAP_ST_OPEN;
				t.Internal.CurrOperation:=	FIOWRAP_OP_SAVEAS;
			

			ELSIF( t.IN.CMD.Open AND NOT(t.Internal.CMD.Open) )THEN

			
				t.Internal.CMD.Open:=	1;
			
				t.OUT.STAT.Busy:=	1;
				t.OUT.STAT.Done:=	0;
						
				t.Internal.State:=			FIOWRAP_ST_OPEN;
				t.Internal.CurrOperation:=	FIOWRAP_OP_OPEN;

			
			ELSIF( t.IN.CMD.AppendToFile AND NOT(t.Internal.CMD.AppendToFile) )THEN

			
				t.Internal.CMD.AppendToFile:=	1;
			
				t.OUT.STAT.Busy:=	1;
				t.OUT.STAT.Done:=	0;
						
				t.Internal.State:=			FIOWRAP_ST_OPEN;
				t.Internal.CurrOperation:=	FIOWRAP_OP_APPEND;

			
			ELSIF( t.IN.CMD.Delete AND NOT(t.Internal.CMD.Delete) )THEN

			
				t.Internal.CMD.Delete:=	1;
			
				t.OUT.STAT.Busy:=	1;
				t.OUT.STAT.Done:=	0;
						
				t.Internal.State:=			FIOWRAP_ST_DELETE;
				t.Internal.CurrOperation:=	FIOWRAP_OP_INVALID;

			
			END_IF
	
			// Reset internal fileCreated whenever done goes false
			t.Internal.FileCreated := t.Internal.FileCreated AND t.OUT.STAT.Done;
	
		FIOWRAP_ST_OPEN:
	
		
			(* Open file *)
		
			t.Internal.FUB.Open.enable:=	1;
			t.Internal.FUB.Open.pDevice:=	ADR(t.IN.PAR.FileDevice);
			t.Internal.FUB.Open.pFile:=		ADR(t.IN.PAR.FileName);
			t.Internal.FUB.Open.mode:=		fiREAD_WRITE;
		
		
			(* Check status *)
				
			IF( t.Internal.FUB.Open.status < FIOWRAP_STAT_DISABLED ) THEN
  			
			
				(* Turn off FUB *)
			
				t.Internal.FUB.Open.enable:=	0;

  
				IF( t.Internal.FUB.Open.status = FIOWRAP_STAT_OK ) THEN
   				
			
				(* All good
					Get Ident, go to appropriate state *)
				
					t.Internal.FileID:=		t.Internal.FUB.Open.ident;
					t.Internal.FileLen:=	t.Internal.FUB.Open.filelen;
				
				
					IF( t.Internal.CurrOperation = FIOWRAP_OP_OPEN ) THEN
	
						t.Internal.State:=	FIOWRAP_ST_READ;
					
					ELSIF( 		(t.Internal.CurrOperation = FIOWRAP_OP_SAVEAS)
						OR	(t.Internal.CurrOperation = FIOWRAP_OP_APPEND)
						)THEN
	
						t.Internal.State:=	FIOWRAP_ST_WRITE;
					
					ELSE
					
						fiowSetError( DINT_TO_UINT(FIOWRAP_ERR_INVALIDOP), t );
					
					END_IF (* check for reading or writing *)
				
				
				ELSIF( t.Internal.FUB.Open.status = fiERR_FILE_NOT_FOUND ) THEN
   
   			
				(* File not found 
					If reading, error
					If writing, create file *)
					
					IF( t.Internal.CurrOperation = FIOWRAP_OP_OPEN ) THEN
	
						fiowSetError( t.Internal.FUB.Open.status, t );
					
					ELSIF( 		(t.Internal.CurrOperation = FIOWRAP_OP_SAVEAS)
						OR	(t.Internal.CurrOperation = FIOWRAP_OP_APPEND)
						)THEN
	
						t.Internal.State:=	FIOWRAP_ST_CREATE;
					
					ELSE
					
						fiowSetError( DINT_TO_UINT(FIOWRAP_ERR_INVALIDOP), t );

					END_IF (* Check for reading or writing *)
				
				
				ELSE
				
			
					(* Other error *)
				
					fiowSetError( t.Internal.FUB.Open.status, t );

				
				END_IF (* If error *)
			
			END_IF (* If done *)
	
	
		FIOWRAP_ST_CREATE:
	
		
			(* Create file *)
		
			t.Internal.FUB.Create.enable:=	1;
			t.Internal.FUB.Create.pDevice:=	ADR( t.IN.PAR.FileDevice );
			t.Internal.FUB.Create.pFile:=	ADR( t.IN.PAR.FileName );
		
		
			(* Check status *)
		
			IF( t.Internal.FUB.Create.status < FIOWRAP_STAT_DISABLED ) THEN
  			
			
				(* Turn off FUB *)
			
				t.Internal.FUB.Create.enable:=	0;
  

				IF( t.Internal.FUB.Create.status = FIOWRAP_STAT_OK ) THEN
   				
			
					(* All good, grab ident, go to write state *)
				
					t.Internal.FileID:=		t.Internal.FUB.Create.ident;
					t.Internal.FileLen:=	0;
					t.Internal.FileCreated:= 1;
				
					IF( 	(t.Internal.CurrOperation = FIOWRAP_OP_SAVEAS)
						OR	(t.Internal.CurrOperation = FIOWRAP_OP_APPEND)
						)THEN
	
						t.Internal.State:=	FIOWRAP_ST_WRITE_HEADER;
					
					ELSE
					
						fiowSetError( DINT_TO_UINT(FIOWRAP_ERR_INVALIDOP), t );
					
					END_IF (* Check for writing *)
			
				
				ELSE
			  	
				
					(* Error *)
				
					fiowSetError( t.Internal.FUB.Create.status, t );
			
				
				END_IF (* If error *)
			
			END_IF (* If done *)
	
		FIOWRAP_ST_WRITE_HEADER:
			
			// skip this if no header
			IF t.IN.PAR.pHeader = 0 OR t.IN.PAR.headerLen = 0 THEN
				t.Internal.State:=	FIOWRAP_ST_WRITE;
				RETURN;
			END_IF
			
			t.Internal.FUB.Write.enable:=	1;
			t.Internal.FUB.Write.ident:=	t.Internal.FileID;
			
			t.Internal.FUB.Write.pSrc:=		t.IN.PAR.pHeader;
			t.Internal.FUB.Write.len:=		t.IN.PAR.headerLen;
			
			(* Check status *)
		
			IF( t.Internal.FUB.Write.status < FIOWRAP_STAT_DISABLED ) THEN
  			
			
				(* Turn off FUB *)
			
				t.Internal.FUB.Write.enable:=	0;
  

				IF( t.Internal.FUB.Write.status = FIOWRAP_STAT_OK ) THEN
   				
			
					(* All good, go to close state *)
					t.Internal.State:=	FIOWRAP_ST_WRITE;
				
				
				ELSE

				
					(* Error *)
					(* Since already opened file, need to close file before going to error state *)
				
					t.Internal.ErrorClose:=	1;
				
					fiowSetError( t.Internal.FUB.Write.status, t );
				
					t.Internal.State:=		FIOWRAP_ST_CLOSE;
			
				
				END_IF (* If error *)
				
			END_IF (* If done *)
				
		FIOWRAP_ST_READ:
	
		
			(* Read from file *)
		
			t.Internal.FUB.Read.enable:=	1;
			t.Internal.FUB.Read.ident:=		t.Internal.FileID;
			t.Internal.FUB.Read.offset:=	t.IN.PAR.offset;
			t.Internal.FUB.Read.pDest:=		t.IN.PAR.pData;
			t.Internal.FUB.Read.len:=		t.IN.PAR.len;
		
		
			(* Check status *)
		
			IF( t.Internal.FUB.Read.status < FIOWRAP_STAT_DISABLED ) THEN
  			
			
				(* Turn off FUB *)
			
				t.Internal.FUB.Read.enable:=	0;
  

				IF( t.Internal.FUB.Read.status = FIOWRAP_STAT_OK ) THEN
   				
			
					(* All good, go to close state *)
				
					t.Internal.State:=	FIOWRAP_ST_CLOSE;
				
				
				ELSE
			  	
				
					(* Error *)
					(* Since already opened file, need to close file before going to error state *)
				
					t.Internal.ErrorClose:=	1;
				
					fiowSetError( t.Internal.FUB.Read.status, t );

					t.Internal.State:=		FIOWRAP_ST_CLOSE;
			
				
				END_IF (* If error *)
			
			END_IF (* If done *)
		
	
		FIOWRAP_ST_WRITE:
	
		
			(* Write to file *)
		
			t.Internal.FUB.Write.enable:=	1;
			t.Internal.FUB.Write.ident:=	t.Internal.FileID;
		
			IF( t.Internal.CurrOperation = FIOWRAP_OP_SAVEAS )THEN
		
				t.Internal.FUB.Write.offset:=	t.IN.PAR.offset + t.IN.PAR.headerLen;
		
			ELSIF( 		(t.Internal.CurrOperation = FIOWRAP_OP_APPEND)
				AND	(t.Internal.FileLen + t.IN.PAR.len <= t.IN.PAR.MaxFileSize)
				)THEN
  			
				t.Internal.FUB.Write.offset:=	t.Internal.FileLen;
			
			ELSIF( (t.Internal.CurrOperation = FIOWRAP_OP_APPEND)
				AND (t.IN.PAR.MultiFile)
				AND (t.Internal.FileLen <> 0)
				)THEN
			
				t.Internal.FUB.Write.enable:= 0;
				t.Internal.CurrOperation:= FIOWRAP_OP_APPEND_NEW;
				t.Internal.State:= FIOWRAP_ST_CLOSE;
				
			ELSE
			
				(* Error *)
				(* Since already opened file, need to close file before going to error state *)
			
				t.Internal.ErrorClose:=	1;
				t.Internal.FUB.Write.enable:=	0;
		
				fiowSetError( DINT_TO_UINT(FIOWRAP_ERR_MAXFILESIZE), t );

				t.Internal.State:=		FIOWRAP_ST_CLOSE;
		
			END_IF (* If error *)
		
		
			t.Internal.FUB.Write.pSrc:=		t.IN.PAR.pData;
			t.Internal.FUB.Write.len:=		t.IN.PAR.len;
		
		
			(* Check status *)
		
			IF( t.Internal.FUB.Write.status < FIOWRAP_STAT_DISABLED ) THEN
  			
			
				(* Turn off FUB *)
			
				t.Internal.FUB.Write.enable:=	0;
  

				IF( t.Internal.FUB.Write.status = FIOWRAP_STAT_OK ) THEN
   				
			
					(* All good, go to close state *)
				
					t.Internal.State:=	FIOWRAP_ST_CLOSE;
				
				
				ELSE

				
					(* Error *)
					(* Since already opened file, need to close file before going to error state *)
				
					t.Internal.ErrorClose:=	1;
				
					fiowSetError( t.Internal.FUB.Write.status, t );
				
					t.Internal.State:=		FIOWRAP_ST_CLOSE;
			
				
				END_IF (* If error *)
			
			END_IF (* If done *)
	
	
		FIOWRAP_ST_RENAME:
		
			t.Internal.FUB.Rename.enable := 1;
		
			(* Check status *)
		
			IF( t.Internal.FUB.Rename.status < FIOWRAP_STAT_DISABLED )THEN
			
				(* Turn off FUB *)
			
				t.Internal.FUB.Rename.enable:= 0;
			
				IF ( t.Internal.FUB.Rename.status = FIOWRAP_STAT_OK ) THEN

					IF( t.Internal.CurrOperation = FIOWRAP_OP_APPEND ) THEN
					
						t.Internal.State:= FIOWRAP_ST_OPEN;
			
					ELSE
					
						t.Internal.State:= FIOWRAP_ST_WAIT;
					
					END_IF
					
				ELSE
					
					(* Error *)
					
					fiowSetError( t.Internal.FUB.Rename.status, t );
					
				END_IF
			
			ELSIF( t.Internal.FUB.Rename.status = FIOWRAP_STAT_DISABLED )THEN
				
				(* Get file name and extension *)
				SplitFileName(ADR(t.IN.PAR.FileName), ADR(t.Internal.Name), ADR(t.Internal.Extension));
				
				IF (NOT (brsstrcmp(ADR(t.IN.PAR.Suffix), ADR('')) = 0)) THEN
					t.Internal.newFileName := CONCAT(t.Internal.Name, CONCAT(t.IN.PAR.Suffix, CONCAT('.', t.Internal.Extension)));
					
				ELSE
					(* Get Time *)
					t.Internal.FUB.GetTime.enable := TRUE;
					t.Internal.FUB.GetTime();
				
					IF( t.Internal.FUB.GetTime.status = 0 )THEN
				
						(* Generate Timestamp *)
						(* YYYY-MM-DD_HH-MM-SS *)
						//GenerateTimestamp(t.Internal.FUB.GetTime.DT1, ADR(t.Internal.Timestamp), SIZEOF(t.Internal.Timestamp));
						DT_TO_DTStructure( t.Internal.FUB.GetTime.DT1, ADR(t.Internal.DTStruct) );
						brsitoa(t.Internal.DTStruct.year, ADR(t.Internal.TempStr));
						t.Internal.Timestamp := CONCAT(t.Internal.TempStr,'-'); // Year
						brsitoa(t.Internal.DTStruct.month, ADR(t.Internal.TempStr));
						t.Internal.Timestamp := CONCAT(t.Internal.Timestamp, CONCAT(t.Internal.TempStr, '-')); // Month
						brsitoa(t.Internal.DTStruct.day, ADR(t.Internal.TempStr));
						t.Internal.Timestamp := CONCAT(t.Internal.Timestamp, CONCAT(t.Internal.TempStr, '_')); // Day
						brsitoa(t.Internal.DTStruct.hour, ADR(t.Internal.TempStr));
						t.Internal.Timestamp := CONCAT(t.Internal.Timestamp, CONCAT(t.Internal.TempStr, '-')); // Hour
						brsitoa(t.Internal.DTStruct.minute, ADR(t.Internal.TempStr));
						t.Internal.Timestamp := CONCAT(t.Internal.Timestamp, CONCAT(t.Internal.TempStr, '-')); // Min
						brsitoa(t.Internal.DTStruct.second, ADR(t.Internal.TempStr));
						t.Internal.Timestamp := CONCAT(t.Internal.Timestamp, t.Internal.TempStr); // Second
					
						(* Combine name with timestamp *)
						(* NAME_TIMESTAMP.EXTENSION *)
						t.Internal.newFileName := CONCAT(t.Internal.Name, CONCAT('_', CONCAT(t.Internal.Timestamp, CONCAT('.', t.Internal.Extension))));	
						//t.Internal.newFileName := CONCAT(t.IN.PAR.FileName, t.Internal.Timestamp);
						//t.IN.PAR.FileName
					ELSE
					
						t.Internal.newFileName := CONCAT(t.Internal.Name, CONCAT('-old.', t.Internal.Extension));
					
					END_IF
					
				END_IF
				
				t.Internal.FUB.Rename.pDevice := ADR(t.IN.PAR.FileDevice);
				t.Internal.FUB.Rename.pName := ADR(t.IN.PAR.FileName);
				t.Internal.FUB.Rename.pNewName := ADR(t.Internal.newFileName);			
				
	
			END_IF
	
		
		FIOWRAP_ST_CLOSE:
	
		
			(* Close file *)
		
			t.Internal.FUB.Close.enable:=	1;
			t.Internal.FUB.Close.ident:=	t.Internal.FileID;
		
		
			(* Check status *)
		
			IF( t.Internal.FUB.Close.status < FIOWRAP_STAT_DISABLED ) THEN
  			
			
				(* Turn off FUB *)
			
				t.Internal.FUB.Close.enable:=	0;
  

				IF( t.Internal.FUB.Close.status = FIOWRAP_STAT_OK ) THEN
   				
			
					IF( t.Internal.ErrorClose ) THEN
					
					
						(* If error close, go to error state *)	
	
						t.Internal.State:=	FIOWRAP_ST_ERROR;
				
					ELSIF( t.Internal.CurrOperation = FIOWRAP_OP_APPEND_NEW )THEN
						
						(* continue with appending *)
						
						t.Internal.CurrOperation:= FIOWRAP_OP_APPEND;
						t.Internal.State:= FIOWRAP_ST_RENAME;
					ELSE
					
					
						(* otherwise, done, set status and go to wait state *)	
					
						t.OUT.STAT.Busy:=	0;
						t.OUT.STAT.Done:=	1;
						
						t.Internal.State:=	FIOWRAP_ST_WAIT;
					
					END_IF (* If ErrorClose *)
				
				
				ELSE
			  	
				
					(* Error *)
				
					fiowSetError( t.Internal.FUB.Close.status, t );
				
				
				END_IF (* If error *)
			
			END_IF (*If done *)
		
	
		FIOWRAP_ST_DELETE:
	
		
			(* Delete file *)
		
			t.Internal.FUB.Delete.enable:=	1;
			t.Internal.FUB.Delete.pDevice:=	ADR(t.IN.PAR.FileDevice);
			t.Internal.FUB.Delete.pName:=	ADR(t.IN.PAR.FileName);		
		
		
			(* Check status *)
		
			IF( t.Internal.FUB.Delete.status < FIOWRAP_STAT_DISABLED ) THEN
  			
			
				(* Turn off FUB *)
			
				t.Internal.FUB.Delete.enable:=	0;
  

				IF( 	(t.Internal.FUB.Delete.status = FIOWRAP_STAT_OK)
					OR	(t.Internal.FUB.Delete.status = fiERR_FILE_NOT_FOUND)
					)THEN
   				
			
					(* Done, set status and go to wait state *)	
					
					t.OUT.STAT.Busy:=	0;
					t.OUT.STAT.Done:=	1;
						
					t.Internal.State:=	FIOWRAP_ST_WAIT;
				
									
				ELSE
			  	
				
					(* Error *)
				
					fiowSetError( t.Internal.FUB.Delete.status, t );
				
				
				END_IF (* If error *)
			
			END_IF (*If done *)
		
	
		FIOWRAP_ST_ERROR:
	
		
			(* Turn off all FUBs, just in case *)
		
			t.Internal.FUB.Open.enable:=	0;
			t.Internal.FUB.Create.enable:=	0;
			t.Internal.FUB.Read.enable:=	0;
			t.Internal.FUB.Write.enable:=	0;
			t.Internal.FUB.Close.enable:=	0;
			t.Internal.FUB.Delete.enable:=	0;
			t.Internal.FUB.Rename.enable:=	0;
			t.Internal.FUB.GetTime.enable:= 0;
	
	
			IF( t.IN.CMD.AcknowledgeError )THEN
			
				t.OUT.STAT.Error:=			0;
				t.OUT.STAT.ErrorID:=		0;
				t.OUT.STAT.ErrorString:=	'';
				t.OUT.STAT.ErrorLevel:=		0;
				t.Internal.ErrorClose:=		0;
				t.Internal.State:=			FIOWRAP_ST_WAIT;
			
			END_IF 
	
	END_CASE
	
	// Copy curent file length to output
	t.OUT.STAT.FileLen := t.Internal.FileLen;

	(* Reset AcknowledgeError CMD *)

	t.IN.CMD.AcknowledgeError:=	0;
			

	(****************************************)
	(* Call FUBs							*)
	(****************************************)

	t.Internal.FUB.Open();
	t.Internal.FUB.Create();
	t.Internal.FUB.Read();
	t.Internal.FUB.Write();
	t.Internal.FUB.Close();
	t.Internal.FUB.Delete();
	t.Internal.FUB.Rename();


	(****************************************)
	(* Set ReadyForCMD						*)
	(****************************************)

	t.OUT.STAT.NewFile:= t.Internal.FileCreated AND t.OUT.STAT.Done;
	t.OUT.STAT.ReadyForCMD:=		NOT(t.OUT.STAT.Busy)
	AND NOT(t.OUT.STAT.Done)
	AND	NOT(t.OUT.STAT.Error);


END_FUNCTION
