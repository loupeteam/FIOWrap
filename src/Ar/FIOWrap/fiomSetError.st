(*
 * File: fiomSetError.st
 * Copyright (c) 2023 Loupe
 * https://loupe.team
 * 
 * This file is part of FIOWrap, licensed under the MIT License.
 * 
  ********************************************************************
 * Implementation of library FIOWrap
 ********************************************************************) 


(********************************************************************)
(* Set error status on FIOWrap 										*)
(********************************************************************)


(* Reset Busy, Done			DONE and TESTED DFB 20111222 *)
(* Set Error				DONE and TESTED DFB 20111222 *)
(* Set ErrorID				DONE and TESTED DFB 20111222 *)
(* Set ErrorLevel			DONE and TESTED DFB 20111222 *)
(* Set State				DONE and TESTED DFB 20111222 *)
(* Set ErrorString			DONE and TESTED DFB 20120131 *)
	

FUNCTION fiomSetError


(****************************************************)
(* Set return value to get rid of compile warning 	*)
(****************************************************)

fiomSetError:=	FALSE;


(************************************************)
(* Set error status								*)
(************************************************)

t.OUT.STAT.Busy:=		0;
t.OUT.STAT.Done:=		0;
t.OUT.STAT.Error:=		1;
t.OUT.STAT.ErrorID:=	ErrorID;
t.OUT.STAT.ErrorLevel:=	3;
t.Internal.State:=		FIOWRAP_ST_ERROR;


(* Set ErrorString *)

CASE ErrorID OF
	
	0: t.OUT.STAT.ErrorString:=	'';
	
	fiERR_INVALID_PATH:				t.OUT.STAT.ErrorString:=	'Invalid path.';
	fiERR_DATA_SIZE:				t.OUT.STAT.ErrorString:=	'Data length is too small (DirRead).';
	fiERR_NO_MORE_ENTRIES:			t.OUT.STAT.ErrorString:=	'No more file handles available.';
	fiERR_NOT_SUPPORTED:			t.OUT.STAT.ErrorString:=	'System error.';
	fiERR_INVALID_TYP:				t.OUT.STAT.ErrorString:=	'Invalid type.';
	fiERR_EXIST:					t.OUT.STAT.ErrorString:=	'File already exists.';
	fiERR_ACCESS:					t.OUT.STAT.ErrorString:=	'Access not possible with the desired mode.';
	fiERR_MODE:						t.OUT.STAT.ErrorString:=	'Illegal mode.';
	fiERR_FILE_NOT_FOUND:			t.OUT.STAT.ErrorString:=	'File not found. Check IN.PAR.FileName.';
	fiERR_FILE_DEVICE:				t.OUT.STAT.ErrorString:=	'File device not found. Check IN.PAR.FileDevice.';
	fiERR_SPACE:					t.OUT.STAT.ErrorString:=	'Not enough memory to write file.';
	fiERR_SEEK:						t.OUT.STAT.ErrorString:=	'Invalid file offset.';
	fiERR_FILE:						t.OUT.STAT.ErrorString:=	'File not allowed.';
	fiERR_LESS_VIRTUAL_MEMORY:		t.OUT.STAT.ErrorString:=	'Not enough memory to write file.';
	fiERR_COM_FILE_OPEN:			t.OUT.STAT.ErrorString:=	'System error.';
	fiERR_COM_FILE_CLOSE:			t.OUT.STAT.ErrorString:=	'System error.';
	fiERR_COM_FILE_READ:			t.OUT.STAT.ErrorString:=	'System error.';
	fiERR_COM_FILE_WRITE:			t.OUT.STAT.ErrorString:=	'System error.';
	fiERR_COM_FILE_IOCTL:			t.OUT.STAT.ErrorString:=	'System error.';
	fiERR_DATA:						t.OUT.STAT.ErrorString:=	'Invalid parameter. Check IN.PAR.pData.';
	fiERR_ASYNC_MANAGER:			t.OUT.STAT.ErrorString:=	'System error.';
	fiERR_FILE_NOT_OPENED:			t.OUT.STAT.ErrorString:=	'File not opened.';
	fiERR_INVALID_DIRECTORY:		t.OUT.STAT.ErrorString:=	'Invalid directory. Check IN.PAR.FileDevice and IN.PAR.FileDirectory.';
	fiERR_DIR_NOT_EXIST:			t.OUT.STAT.ErrorString:=	'Directory does not exist. Check IN.PAR.FileDevice and IN.PAR.FileDirectory.';
	fiERR_DIR_NOT_EMPTY:			t.OUT.STAT.ErrorString:=	'Directory is not empty.';
	fiERR_DIR_ALREADY_EXIST:		t.OUT.STAT.ErrorString:=	'Directory already exists.';
	fiERR_DETMEMINFO:				t.OUT.STAT.ErrorString:=	'System error.';
	fiERR_NOT_ENOUGH_FREEMEM:		t.OUT.STAT.ErrorString:=	'Not enough memory to write file.';
	fiERR_DIR_INVALID_HANDLE:		t.OUT.STAT.ErrorString:=	'System error.';
	fiERR_PARAMETER:				t.OUT.STAT.ErrorString:=	'System error.';
	fiERR_DEVICE_ALREADY_EXIST:		t.OUT.STAT.ErrorString:=	'Device already exists.';
	fiERR_DEVICE_INVALID_HANDLE:	t.OUT.STAT.ErrorString:=	'Invalid device handle.';
	fiERR_NETIO_IP_UNEQUAL:			t.OUT.STAT.ErrorString:=	'IP address error. Check hostname.';
	fiERR_INIT:						t.OUT.STAT.ErrorString:=	'System error.';
	fiERR_DEVICE_DRIVER:			t.OUT.STAT.ErrorString:=	'System error.';
	fiERR_DEVICE_MANAGER:			t.OUT.STAT.ErrorString:=	'File device error. Check IN.PAR.FileDevice.';
	fiERR_SYSTEM:					t.OUT.STAT.ErrorString:=	'System error.';
	
	FIOWRAP_ERR_INVALIDOP:			t.OUT.STAT.ErrorString:=	'Internal error.';
	FIOWRAP_ERR_INVALIDFILTER:		t.OUT.STAT.ErrorString:=	'Input required for IN.PAR.ItemName. Set IN.PAR.ItemName := $'*$' to mamange all files/directories.';	
	FIOWRAP_ERR_INVALIDDIR:			t.OUT.STAT.ErrorString:=	'Cannot manage in root directory. Check IN.PAR.FileDevice and IN.PAR.FileDirectory.';		
	FIOWRAP_ERR_MAXFILESIZE:		t.OUT.STAT.ErrorString:=	'Error while appending: maximum file size would be exceeded.';
	
	ELSE	t.OUT.STAT.ErrorString:=	'Unknown error.';
	
END_CASE


END_FUNCTION
