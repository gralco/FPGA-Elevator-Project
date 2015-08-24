set projDir "/home/ekuzmenko/mojo-ide-B1.2.1/Projects/Elevator/work/planAhead"
set projName "Elevator"
set topName top
set device xc6slx9-2tqg144
if {[file exists "$projDir/$projName"]} { file delete -force "$projDir/$projName" }
create_project $projName "$projDir/$projName" -part $device
set_property design_mode RTL [get_filesets sources_1]
set verilogSources [list "/home/ekuzmenko/mojo-ide-B1.2.1/Projects/Elevator/work/verilog/mojo_top.v" "/home/ekuzmenko/mojo-ide-B1.2.1/Projects/Elevator/work/verilog/elevator.v"]
import_files -fileset [get_filesets sources_1] -force -norecurse $verilogSources
set ucfSources [list "/home/ekuzmenko/mojo-ide-B1.2.1/Projects/Elevator/constraint/mojo.ucf"]
import_files -fileset [get_filesets constrs_1] -force -norecurse $ucfSources
set_property top mojo_top [get_property srcset [current_run]]
set_property -name {steps.bitgen.args.More Options} -value {-g Binary:Yes -g Compress} -objects [get_runs impl_1]
update_compile_order -fileset sources_1
launch_runs -runs synth_1
wait_on_run synth_1
launch_runs -runs impl_1
wait_on_run impl_1
launch_runs impl_1 -to_step Bitgen
wait_on_run impl_1
