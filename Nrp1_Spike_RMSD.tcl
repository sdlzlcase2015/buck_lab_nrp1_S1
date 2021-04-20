set mol [mol new complex.psf type psf waitfor all]
mol addfile prot.dcd type dcd waitfor all molid $mol
package require pbctools
pbc unwrap -sel "protein"
set outfile [open rmsd.txt w]
set nf [molinfo top get numframes]
set frame0 [atomselect top "protein and name CA " frame 0]
set sel [atomselect top "protein and name CA"]
# rmsd calculation loop
for { set i 1 } { $i <= $nf } { incr i } {
$sel frame $i
set j [expr $i*0.1]
$sel move [measure fit $sel $frame0]
puts $outfile "$j [measure rmsd $sel $frame0]"
}
close $outfile
exit  

