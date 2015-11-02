FUNCTION read_scan,filename, DATA_DIR=data_dir

;+
; NAME: read_scan
;
;
;
; PURPOSE: read a sharc II fits file produced by crush and return a
;          structure containing the necessary data to further processing
;
;
;
; CATEGORY: I/O
;
;
;
; CALLING SEQUENCE: read_scan(filename)
;
;
;
; INPUTS: filename : the name of the file
;
;
;
; OPTIONAL INPUTS:
;
;
;
; KEYWORD PARAMETERS:
;         DATA_DIR : the directory where the fits file are, can be
;                    changed for your default value directly below
;
;
; OUTPUTS: 
;         a data structure (see at the end)
;
;
;
; OPTIONAL OUTPUTS:
;
;
;
; COMMON BLOCKS:
;
;
;
; SIDE EFFECTS:
;
;
;
; RESTRICTIONS:
;
;
;
; PROCEDURE:
;      Intensive use of ASTRON routines [1] 
;      [1] http://idlastro.gsfc.nasa.gov/homepage.html
;
;
; EXAMPLE:
;
;
;
; MODIFICATION HISTORY:
;            2004 feb created
;            2005 may cleaning a rewritting
;-


IF NOT KEYWORD_SET(DATA_DIR) THEN BEGIN
    DATA_DIR = '/home/beelen/Projects/Survey/2004_QSOs_CSO/data/crush-1.42-deep/'
    PRINT,"WW - NOT THE final version"
ENDIF

IF NOT FILE_TEST(DATA_DIR+filename) THEN BEGIN
    PRINT, "Error - file not found, check filename & PATH"
    RETURN, 0
ENDIF

signal = MRDFITS(DATA_DIR+filename,0,header,/DSCALE,/SILENT)
time   = MRDFITS(DATA_DIR+filename,1,/DSCALE,/SILENT)
error  = MRDFITS(DATA_DIR+filename,2,/DSCALE,/SILENT)
SN     = MRDFITS(DATA_DIR+filename,3,/DSCALE,/SILENT)

V2JY    = SXPAR(header,'V2JY')


; Put everything internally to Jy/deg^2
conv = 1

IF STRMATCH(SXPAR(header,'BUNIT'),'V*') EQ 1 THEN BEGIN
; convert from V/intrument pixel 
    conv = V2JY*4.77*4.93*!arcsec2deg^2 
ENDIF

IF STRMATCH(SXPAR(header,'BUNIT'),'uV*') EQ 1 THEN BEGIN
; convert from nV  
    conv = 1.d6*V2JY*4.77*4.93*!arcsec2deg^2 
ENDIF

IF STRMATCH(SXPAR(header,'BUNIT'),'Jy/arcsec**2*') EQ 1 THEN BEGIN
; convert from Jy/arcsec**2
    conv = !arcsec2deg^2         
ENDIF

signal = signal/conv
error  = error/conv

; Compute every pixel coordinates 

sizex = N_ELEMENTS(signal[*,0])
sizey = N_ELEMENTS(signal[0,*])
X = FINDGEN(sizex)
Y = FINDGEN(sizey)
X_tab = X # (Y*0+1)
Y_tab = (X*0+1) # Y

; position in decimal degree
xyad, header, X_tab,Y_tab,A_tab,D_tab


; return the corresponding structure
return, {filename: filename, $
         header:   header,   $
         signal:   signal,   $
         time:     time,     $
         error:    error,    $
         SN:       SN,       $
         A_tab:    A_tab,    $
         D_tab:    D_tab     $
        }



END
