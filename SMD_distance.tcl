###################################
#   distance seltext1 seltext2 N_d f_r_out f_d_out
#    where seltext1 and seltext2 are the selection texts for the groups of atoms between which the distance is measured, N_d is the number of bins for the distribution, and f_r_out and f_d_out are the file names to where the output distance vs. time and distance distribution will be written. 
###################################

set mol [mol new complex.psf type psf waitfor all]
mol addfile complexcen.pdb type pdb waitfor all molid $mol  
mol addfile smd.dcd type dcd waitfor all molid $mol  

# Choose atom selections
set seltext1 "segname SA1 SB1 SC1 and (resid 1 to 541)"
set seltext2 "segname SA2 SB2 SC2"
set sel1 [atomselect top "$seltext1"]
set sel2 [atomselect top "$seltext2"]

# Get the number of frames in the trajectory and assign this value to the variable nf
set nf [molinfo top get numframes]

# Open file specified by the variable f_r_out
set outfile [open disttime w]

# Loop over all frames
for {set i 0} {$i < $nf} {incr i} {
#Write out the frame number and update the selections to the current frame
puts "frame $i of $nf"
$sel1 frame $i
$sel2 frame $i

set com1 [measure center $sel1 weight mass]
set com2 [measure center $sel2 weight mass]
set z1 [lindex $com1 2]
set z2 [lindex $com2 2]
#At each frame i, find the distance by subtracting one vector from the other (command vecsub) and computing the length of the resulting vector (command veclength), assign that value to an array element simdata($i.r), and print a frame-distance entry to a file
set dist [veclength [vecsub $z1 $z2]]

puts $outfile "$i $dist"
        
}

close $outfile

exit
