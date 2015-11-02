PRO plot_scan,filename,out_pos,complete_name, $
              SURFACE=surface,S2N=s2n,myS2N=mys2n,NOISE=noise,TIME=time,$
              SMOOTH=smooth,ASPECT=aspect,CROP=crop,$
              CROSS=cross, TYPE=type, CONTOURS_TIME=contours_time,$
              NOWEDGE=nowedge
;+
; NAME: plot_scan
;
;
;
; PURPOSE: plotting a sharc II fits file produced by crush, but can be
;          used for any fits file, as long as the read_scan procedure
;          is rewritten in the correct way
;
;
;
; CATEGORY: plotting
;
;
;
; CALLING SEQUENCE: plot_scan,filename,
;                             [out_pos, complete_name],
;                             [surface=,s2n=,noise=,time=,smooth=,aspect=,crop=,cross=,type=, contours_time=]
;
;
;
; INPUTS: filename : the fits file name to display
;
;
;
; OPTIONAL INPUTS:
;         complete_name : the name to display on the top right corner
;
;
; KEYWORD PARAMETERS:
;         surface       : draw a 3D surface instead of a 2D image
;         s2n           : display Signal to noise 
;         noise         : display noise
;         time          : display integrated time per pixel 
;         smooth        : smooth the image with a 8.5" FWHM 2D gaussian
;         crop          : crop date with less that the specified value in
;                         seconds (default cropping below 10 seconds)
;         cross         : display a cross around the pointed position*
;         type          : change the labbeling of axis; 0 (default) offset from the
;                         pointed position; 1 = absolute labelling
;         contours_time : specify contour of integrated time to be
;                         displayed (default 5 and 10 min / pixel)
;         nowedge       : do not plot a wedge
;        
;
; OUTPUTS:
;         
;
;
; OPTIONAL OUTPUTS:
;        out_pos : the position box for further overplotting
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
;      Intensive use of ASTRON routines [1] and based on IMDISP [2],
;      it also use the Coyote library [3], and the read_scan routine
;      [1] http://idlastro.gsfc.nasa.gov/homepage.html
;      [2] http://cimss.ssec.wisc.edu/~gumley/imdisp.html
;      [3] http://www.dfanning.com/documents/programs.html
;
; EXAMPLE:
;
;
;
; MODIFICATION HISTORY:
;            2004 feb created
;            2005 may cleaning a rewritting
;-


scan = read_scan(filename)

sizex = N_ELEMENTS(scan.A_tab[*,0])
sizey = N_ELEMENTS(scan.D_tab[0,*])

IF KEYWORD_SET(ASPECT) THEN $
  ASPECT = (TOTAL(MINMAX(scan.D_tab)*[-1,1])/N_ELEMENTS(scan.D_tab[0,*]))/ $
  (TOTAL(MINMAX(scan.A_tab)*[-1,1])/N_ELEMENTS(scan.A_tab[*,0]))/cos(mean(scan.D_tab,/NAN)*!pi/180) $
ELSE $
  ASPECT = 1

to_plot = scan.signal
colorbar_format = '(F10.2)'
colorbar_title = TEXTOIDL(' Signal (Jy/deg^2)')

; set the overplot contour of integrated time (in minute)
IF NOT KEYWORD_SET(contours_time) THEN $
  contours_time = [5,10]

IF KEYWORD_SET(S2N) THEN BEGIN 
  to_plot = scan.SN
  colorbar_format='(F4.1)'
  colorbar_title = 'Signal to Noise ratio'
ENDIF

IF KEYWORD_SET(myS2N) THEN BEGIN 
  to_plot = scan.signal/scan.error
  colorbar_format='(F4.1)'
  colorbar_title = 'my signal to Noise ratio'
ENDIF

IF KEYWORD_SET(NOISE) THEN BEGIN
  to_plot = scan.error
  colorbar_title=TEXTOIDL(' Error (Jy/deg^2)')
ENDIF

IF KEYWORD_SET(TIME) THEN BEGIN
  to_plot = scan.time/60
  colorbar_title= 'Integration time per pixel (minutes)'
ENDIF

IF KEYWORD_SET(SMOOTH) THEN BEGIN
   ; smooth by a 8.5 arcsec FWHM gaussian

    mask = WHERE(FINITE(scan.signal) EQ 0)
    to_plot[mask]= 0
    
    sigma_real = 8.5*!arcsec2deg/(2*SQRT(2*ALOG(2)))
    
    gauss_x = FINDGEN(sizex/3)/(sizex/3)*TOTAL(MINMAX(scan.A_tab)*[-1,1])/3-TOTAL(MINMAX(scan.A_tab)*[-1,1])/6
    gauss_y = FINDGEN(sizey/3)/(sizey/3)*TOTAL(MINMAX(scan.D_tab)*[-1,1])/3-TOTAL(MINMAX(scan.D_tab)*[-1,1])/6

    gauss_tab_x = gauss_x # (gauss_y*0 + 1)             
    gauss_tab_y = (gauss_x*0 + 1) # gauss_y 
    
    gaussian = circular_gaussian(gauss_tab_x, $
                                 gauss_tab_y,$
                                 [0.,$
                                  1/(2*!pi*sigma_real*sigma_real), 0., 0.,$
                                  sigma_real, sigma_real, 0])
    gaussian = gaussian/total(gaussian)
   
    fft2_to_plot = convolve(to_plot,gaussian)
    fft2_to_plot[mask] = !VALUES.F_NAN
    to_plot = fft2_to_plot
    
ENDIF



IF KEYWORD_SET(crop) THEN BEGIN
    mask   = WHERE(scan.int_time LT (crop >10.0)) ; remove all pixel  with integration time less than 10 sec 
    to_plot[mask] = !VALUES.F_NAN
ENDIF



; Define the color range for the plot...

RANGE = MINMAX(to_plot,/NAN)

IF MAX(scan.time,/NAN) GE min(contours_time)*60 THEN $
  RANGE = MINMAX(to_plot[WHERE(scan.time GE min(contours_time)*60)],/NAN)

; ... and draw the image

IF NOT KEYWORD_SET(SURFACE) THEN BEGIN
    
    CHARSIZE = !P.CHARSIZE
    MARGIN=0.1
    IF STRMATCH(!D.NAME,'PS') THEN BEGIN 
        mask = WHERE(FINITE(scan.signal) EQ 0)
        to_plot[mask]=MAX(to_plot+1,/NAN)
        CHARSIZE=0.7
        MARGIN=0.15
    ENDIF

    ; display the map with ...
    loadct,1
    imdisp,to_plot,out_pos=out_pos,/erase, $
      ASPECT=ASPECT,$
      RANGE=RANGE, MARGIN=MARGIN

    ; ... the colorbar
    IF NOT KEYWORD_SET(nowedge) THEN BEGIN 
        colorbar,RANGE=range,/right,/vertical,$
          position=[out_pos[2],out_pos[1],out_pos[2]+0.01,out_pos[3]],$
          FORMAT=colorbar_format, title=colorbar_title
    ENDIF
    colors

    ; ... the contour for integration time [ 5 and 10 minutes ]
    contour, scan.time/60,  position=out_pos, /NOERASE, $
      XSTYLE=5,YSTYLE=5, levels=contours_time, /follow,color=7,thick=3
    
    ; Plot the labels
    imcontour,scan.signal,scan.header,TYPE=type,position=out_pos,$
      /noerase, SUBTITLE=" ",/NODATA,CHARSIZE=CHARSIZE
    
    ; display the name if needed
    IF N_ELEMENTS(complete_name) NE 0 THEN $
      XYOUTS,MAX(!X.CRANGE)-1*TOTAL([-1,1]*MINMAX(!X.CRANGE))/20, $
      MAX(!Y.CRANGE)-1*TOTAL([-1,1]*MINMAX(!Y.CRANGE))/20, $
      complete_name
    
    ; Display a cross at the pointed position 
    IF KEYWORD_SET(cross) THEN BEGIN

        source_RA = SXPAR(scan.header,'CRVAL1')
        source_DEC = SXPAR(scan.header,'CRVAL2')
 
        FWHM = 8.5*!arcsec2deg

        cross_size = [1.5,3]
        adxy,scan.header,[1,1]*source_RA,source_DEC+cross_size*FWHM,x,y
        oplot,x,y,thick=5,color=7
        adxy,scan.header,[1,1]*source_RA,source_DEC-cross_size*FWHM,x,y
        oplot,x,y,thick=5,color=7
        adxy,scan.header,source_RA+cross_size*FWHM,[1,1]*source_DEC,x,y
        oplot,x,y,thick=5,color=7
        adxy,scan.header,source_RA-cross_size*FWHM,[1,1]*source_DEC,x,y
        oplot,x,y,thick=5,color=7
        

    ENDIF



ENDIF ELSE BEGIN

RANGE=RANGE/3*4
    shade_surf,to_plot,scan.A_tab,scan.D_tab,$
      /XSTYLE,/YSTYLE,$
      ZRANGE=[1,2]*RANGE,$
      XTITLE="RA",YTITLE="DEC",TITLE=filename
ENDELSE

END


