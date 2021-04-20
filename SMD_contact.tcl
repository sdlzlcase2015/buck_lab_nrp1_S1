set mol [mol new complex.psf type psf waitfor all]
mol addfile smd.dcd type dcd waitfor all molid $mol
package require pbctools

set n [molinfo top get numframes]
set output [open "ContactnumberS1D.dat" w]
for {set i 0} {$i < $n} {incr i} {
	molinfo top set frame $i
        set all [atomselect top all]
  
	set contact1 "(noh and segname  SA2 SB2 SC2 and resid 686 to 1146) and same residue as within 4 of (noh and resid 640 to 685 and segname  SC1)"
        set selcontact1 [atomselect top $contact1]          
        $selcontact1 set beta 1
        set contactres [atomselect top "name CA and beta > 0"]
        $selcontact1 delete
        set contactlist [$contactres get resid]
        $contactres delete
        set l2 [llength $contactlist]
        puts $output "$i \t $l2"        
        $all set beta 0
        

}
puts "\t \t progress: $n/$n"
puts "Done."	
puts "output file: Contact.dat"
close $output
quit
