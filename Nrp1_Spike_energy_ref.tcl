mol new ionized.psf 
mol addfile ionized.pdb
set all [atomselect top "all"]
$all set beta 0
set protA [atomselect top "protein and segname SA SB SC1 SC2"]
$protA set beta 1
set protB [atomselect top "protein and segname NRP"]
$protB set beta 2
$all writepdb s.pdb
exit

