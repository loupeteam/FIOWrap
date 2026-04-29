
PROGRAM _INIT
	
	FIOWrapper.IN.PAR.FileDevice := 'USER';
	FIOWrapper.IN.PAR.FileName := 'exampleLog.txt';
	
	exampleLog := 
'11/13/2023 3:16PM, a thing happened
11/14/2023 3:16PM, a thing happened
11/15/2023 3:16PM, a thing happened
11/16/2023 3:16PM, a thing happened
11/17/2023 3:16PM, a thing happened
11/18/2023 3:16PM, a thing happened
11/19/2023 3:16PM, a thing happened
11/20/2023 3:16PM, a thing happened
11/21/2023 3:16PM, a thing happened
11/22/2023 3:16PM, a thing happened
11/23/2023 3:16PM, a thing happened
11/24/2023 3:16PM, a thing happened
11/25/2023 3:16PM, a thing happened
11/26/2023 3:16PM, a thing happened
11/27/2023 3:16PM, a thing happened
11/28/2023 3:16PM, a thing happened
';
	newLogEntry := 'NEW ENTRY$r$n';
	
	data := exampleLog;
	
	FIOWrapper.IN.PAR.pData := ADR(data);
	FIOWrapper.IN.PAR.len := brsstrlen(ADR(data));
	
	header := 'timestamp, value$r$n';
	
	FIOWrapper.IN.PAR.pHeader := ADR(header);
	FIOWrapper.IN.PAR.headerLen := brsstrlen(ADR(header));
	
	FIOWrapper.IN.PAR.MaxFileSize := 630;
	FIOWrapper.IN.PAR.MultiFile := TRUE;
	
END_PROGRAM

PROGRAM _CYCLIC
	
	IF loadExampleLog THEN
		loadExampleLog := FALSE;
		data := exampleLog;
	END_IF
	
	IF loadAppendEntry THEN
		loadAppendEntry := FALSE;
		data := newLogEntry;
	END_IF
	
	IF FIOWrapper.IN.CMD.AppendToFile OR FIOWrapper.IN.CMD.SaveAs THEN
		FIOWrapper.IN.PAR.headerLen := brsstrlen(ADR(header));
		FIOWrapper.IN.PAR.len := brsstrlen(ADR(data));
	END_IF
	
	FIOWrapFn_Cyclic(FIOWrapper);

	brsmemset(ADR(FIOWrapper.IN.CMD),0,SIZEOF(FIOWrapper.IN.CMD));
	
END_PROGRAM

