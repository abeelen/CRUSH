> Note that those scripts where made for use with CRUSH I. Although they could still apply with the newest CRUSH II software, they have not been tested.

SHARC II / CRUSH
================

In order to make batch reduction with [CRUSH][CRUSH], I also wrote some shell scripts to simplify this process.

You have to change the ```config.sh``` to set the correct path for your configuration. You also need to create a target_sources file in the ```$LIST_DIR``` directory which list all your target sources name as reported in the fits files. Run the ```make_list.sh``` script to produce scan list for each target source. You can now reduce the complete project by running ```reduce_target.sh``` or individual sources with ```reduce_source.sh source_name```
￼
Shell scripts to reduce [SHARC II][SHARCII] project in batch with [CRUSH][CRUSH]
--------------------------------------------------------------------------------

- ```config.sh``` : define all the variable parameters/path
- ```make_list.sh``` : make the scan lists for target sources
- ```reduce_source.sh``` : reduce one source
- ```reduce_target.sh``` : reduce all the target sources


[IDL][IDL] scripts to display [CRUSH][CRUSH] reduced [SHARC II][SHARCII] data
-----------------------------------------------------------------------------

I also wrote a few [IDL][IDL] scripts I use to display astronomical maps taken with [SHARC II][SHARCII] and reduced with CRUSH. They made intensive use of the [IDL Astronomy User's Library][ASTRON] and [IMDISP][IMDISP] library.

You have to change the default path in read_scan.pro, and then you case use the plot_scan routine with a least one argument, the fits file name, to display the signal (default), the noise (/noise), the signal-to-noise ratio (/s2n), or the integrated time (/time). You can also smooth the map to the FWHM of the CSO (/smooth), force the correct aspect ratio of the image (/aspect), crop the pixel with integrated time less than a value (crop=value), put a cross on the pointed position (/cross), change the display of the axis - offset (default) or absolute (/type), change the contours wrt to time (contours_time=[0,5]), and suppress the wedge (/nowedge)

The ```plot_scan``` routine is in fact more general and could be use with any kind of astronomical image, as long as the structure returned by the ```read_scan``` routine is filled with the right values.

- ```read_scan.pro``` : read the fits file; unit conversions; return a structure containing the data
- ```plot_scan.pro``` : display the scan with various options

[CRUSH]: http://www.submm.caltech.edu/~sharc/crush/index.htm
[SHARCII]: http://www.submm.caltech.edu/~sharc/http://www.submm.caltech.edu/~sharc/
[IDL]: http://www.exelisvis.com/docs/using_idl_home.htmlscripts "The Interactive Data Language"
[ASTRON]: http://idlastro.gsfc.nasa.gov/ "The IDL Astronomy User's LibraryThe IDL Astronomy User's Library"
[IMDISP]: http://www.exelisvis.com/docs/imdisp.html
