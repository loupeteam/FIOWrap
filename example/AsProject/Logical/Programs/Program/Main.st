
PROGRAM _INIT
	
	FIOWrapper.IN.PAR.FileDevice := 'USER';
	FIOWrapper.IN.PAR.FileName := 'exampleLog.txt';
	
	exampleLog := '11/13/2023 3:16PM, a thing happened
11/13/2023 3:16PM, a thing happened
11/13/2023 3:16PM, a thing happened
11/13/2023 3:16PM, a thing happened
11/13/2023 3:16PM, a thing happened
11/13/2023 3:16PM, a thing happened
11/13/2023 3:16PM, a thing happened
11/13/2023 3:16PM, a thing happened
11/13/2023 3:16PM, a thing happened
11/13/2023 3:16PM, a thing happened
11/13/2023 3:16PM, a thing happened
11/13/2023 3:16PM, a thing happened
11/13/2023 3:16PM, a thing happened
11/13/2023 3:16PM, a thing happened
11/13/2023 3:16PM, a thing happened
11/13/2023 3:16PM, a thing happened';
	
	FIOWrapper.IN.PAR.pData := ADR(exampleLog);
	FIOWrapper.IN.PAR.len := brsstrlen(ADR(exampleLog));
	
	header := 'timestamp, value$r$n';
	
	FIOWrapper.IN.PAR.pHeader := ADR(header);
	FIOWrapper.IN.PAR.headerLen := brsstrlen(ADR(header));
	
	FIOWrapper.IN.PAR.MaxFileSize := 300;
	FIOWrapper.IN.PAR.MultiFile := TRUE;
	
END_PROGRAM

PROGRAM _CYCLIC
	
	IF FIOWrapper.IN.CMD.AppendToFile OR FIOWrapper.IN.CMD.SaveAs THEN
		FIOWrapper.IN.PAR.len := brsstrlen(ADR(exampleLog));
	END_IF
	
	FIOWrapFn_Cyclic(FIOWrapper);

	brsmemset(ADR(FIOWrapper.IN.CMD),0,SIZEOF(FIOWrapper.IN.CMD));
	
END_PROGRAM

