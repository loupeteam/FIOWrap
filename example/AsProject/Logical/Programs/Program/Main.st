
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	FIOWrapFn_Cyclic(FIOWrapper);
	
	IF (OpenRecipeFile) THEN

		OpenRecipeFile := 0;

		FIOWrapper.IN.PAR.FileDevice := 'USER';
		FIOWrapper.IN.PAR.FileName := 'rec1.rec';
		FIOWrapper.IN.PAR.pData := ADR(Recipe);
		FIOWrapper.IN.PAR.len := SIZEOF(Recipe);

		FIOWrapper.IN.CMD.Open := 1;

	END_IF

	IF (SaveRecipeFile) THEN

		SaveRecipeFile := 0;

		FIOWrapper.IN.PAR.FileDevice := 'USER';
		FIOWrapper.IN.PAR.FileName := 'rec1.rec';
		FIOWrapper.IN.PAR.pData := ADR(Recipe);
		FIOWrapper.IN.PAR.len := SIZEOF(Recipe);

		FIOWrapper.IN.CMD.SaveAs := 1;

	END_IF

	IF (FIOWrapper.OUT.STAT.Done) THEN
		FIOWrapper.IN.CMD.Open := 0;
		FIOWrapper.IN.CMD.SaveAs := 0;
	END_IF
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

