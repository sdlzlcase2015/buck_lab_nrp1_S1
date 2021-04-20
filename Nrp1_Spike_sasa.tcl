###############################################################
# sasa.tcl                                                    #
# DESCRIPTION:                                                #
#    This script is quick and easy to provide procedure       #
# for computing the Solvent Accessible Surface Area (SASA)    #
# of Protein and allows Users to select regions of protein.   #
#                                                             #   
# EXAMPLE USAGE:                                              #
#         source sasa.tcl                                     #
#         Selection: chain A and resid 1                      #
#                                                             #
#   AUTHORS:                                                  #
#	Sajad Falsafi (sajad.falsafi@yahoo.com)               #
#       Zahra Karimi                                          # 
#       3 Sep 2011                                           #
###############################################################
set mol [mol new complex.psf type psf waitfor all]
mol addfile prot.dcd type dcd waitfor all molid $mol 
package require pbctools
pbc unwrap -sel "protein"
# selection
set proteinsel1 "protein and segname SA SB SC1 SC2 or segname ION"
set protein1 [atomselect top $proteinsel1]
set proteinsel2 "protein and segname NRP or segname ION"
set protein2 [atomselect top $proteinsel2]
set proteinselt "protein  or segname ION"
set proteint [atomselect top $proteinselt]
set n [molinfo top get numframes]
set output [open "SASA.dat" w]
# sasa calculation loop
for {set i 1000} {$i <= $n} {incr i} {   
        if {$i%10==0}     {
	molinfo top set frame $i
        $protein1 frame $i  
        $protein2 frame $i  
        $proteint frame $i  
        #set residlist [lsort -unique [$protein get resid]]
        #puts $residlist
        set selres1 "protein and segname SA SB SC1 SC2 "
        set selres2 "protein and segname NRP"
        set selrest "protein"
        #set selres "protein and segname S and noh "
        set sel1 [atomselect top $selres1]
        set sel2 [atomselect top $selres2]
        set selt [atomselect top $selrest]
        set sasa1 [measure sasa 1.4 $protein1 -restrict $sel1]
        set sasa2 [measure sasa 1.4 $protein2 -restrict $sel2]
        set sasat [measure sasa 1.4 $proteint -restrict $selt]
        set diff [expr $sasa1+$sasa2-$sasat]
        puts "\t \t progress: $i/$n"
        puts $output "$i \t $diff \t $sasa1 \t $sasa2 \t $sasat"   
        $sel1 delete
        $sel2 delete 
        $selt delete
        } 	
}
#puts "\t \t progress: $n/$n"
puts "Done."	
puts "output file: SASA.dat"
close $output
exit
                                      

