#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Tue Nov 25 17:03:43 2025                
#                                                     
#######################################################

#@(#)CDS: Innovus v21.15-s110_1 (64bit) 09/23/2022 13:08 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: NanoRoute 21.15-s110_1 NR220912-2004/21_15-UB (database version 18.20.592) {superthreading v2.17}
#@(#)CDS: AAE 21.15-s039 (64bit) 09/23/2022 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: CTE 21.15-s038_1 () Sep 20 2022 11:42:13 ( )
#@(#)CDS: SYNTECH 21.15-s012_1 () Sep  5 2022 10:25:51 ( )
#@(#)CDS: CPE v21.15-s076
#@(#)CDS: IQuantus/TQuantus 21.1.1-s867 (64bit) Sun Jun 26 22:12:54 PDT 2022 (Linux 3.10.0-693.el7.x86_64)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
win
set init_design_uniquify 1
set init_lef_file { /research/ece/lnis-teaching/Designkits/tsmc180nm/full_custom_lib/lef/tech.lef  /research/ece/lnis-teaching/Designkits/tsmc180nm/full_custom_lib/lef/sclib_tsmc180.lef  /research/ece/lnis-teaching/Designkits/tsmc180nm/full_custom_lib/lef/padlib_tsmc180.lef  /research/ece/lnis-teaching/Designkits/tsmc180nm/full_custom_lib/lef/sclib_tsmc180_antenna.lef  /research/ece/lnis-teaching/Designkits/tsmc180nm/arm_ip/RA1SHD_RD/RA1SHD_RD.vclef  /research/ece/lnis-teaching/Designkits/tsmc180nm/arm_ip/RA1SHD_RD/RA1SHD_RD_ant.lef  /research/ece/lnis-teaching/Designkits/tsmc180nm/arm_ip/RF2SH/RF2SH.vclef  /research/ece/lnis-teaching/Designkits/tsmc180nm/arm_ip/RF2SH/RF2SH_ant.lef }
set init_mmmc_file { CONF/picosoc.view }
set init_verilog { HDL/GATE/top_pad_m.v }
set init_io_file { SCRIPTS/place_io_pad.io }
set init_pwr_net { VDD }
set init_gnd_net { VSS }
init_design
saveDesign DBS/top_pad-import.enc
setDrawView fplan
fit
floorPlan -site core7T -s 1070 910 80 80 80 80
setDrawView fplan
fit
saveDesign DBS/top_pad-fplan.enc
globalNetConnect VDD -type pgpin -pin VDD -all -verbose
globalNetConnect VSS -type pgpin -pin VSS -all -verbose
globalNetConnect VDD -type tiehi
globalNetConnect VSS -type tielo
deleteIoFiller
addIoFiller -cell pad_fill_32 -prefix FILLER -side n
addIoFiller -cell pad_fill_16 -prefix FILLER -side n
addIoFiller -cell pad_fill_8 -prefix FILLER -side n
addIoFiller -cell pad_fill_4 -prefix FILLER -side n
addIoFiller -cell pad_fill_2 -prefix FILLER -side n
addIoFiller -cell pad_fill_1 -prefix FILLER -side n
addIoFiller -cell pad_fill_01 -prefix FILLER -side n
addIoFiller -cell pad_fill_005 -prefix FILLER -side n -fillAnyGap
addIoFiller -cell pad_fill_32 -prefix FILLER -side s
addIoFiller -cell pad_fill_16 -prefix FILLER -side s
addIoFiller -cell pad_fill_8 -prefix FILLER -side s
addIoFiller -cell pad_fill_4 -prefix FILLER -side s
addIoFiller -cell pad_fill_2 -prefix FILLER -side s
addIoFiller -cell pad_fill_1 -prefix FILLER -side s
addIoFiller -cell pad_fill_01 -prefix FILLER -side s
addIoFiller -cell pad_fill_005 -prefix FILLER -side s -fillAnyGap
addIoFiller -cell pad_fill_32 -prefix FILLER -side e
addIoFiller -cell pad_fill_16 -prefix FILLER -side e
addIoFiller -cell pad_fill_8 -prefix FILLER -side e
addIoFiller -cell pad_fill_4 -prefix FILLER -side e
addIoFiller -cell pad_fill_2 -prefix FILLER -side e
addIoFiller -cell pad_fill_1 -prefix FILLER -side e
addIoFiller -cell pad_fill_01 -prefix FILLER -side e
addIoFiller -cell pad_fill_005 -prefix FILLER -side e -fillAnyGap
addIoFiller -cell pad_fill_32 -prefix FILLER -side w
addIoFiller -cell pad_fill_16 -prefix FILLER -side w
addIoFiller -cell pad_fill_8 -prefix FILLER -side w
addIoFiller -cell pad_fill_4 -prefix FILLER -side w
addIoFiller -cell pad_fill_2 -prefix FILLER -side w
addIoFiller -cell pad_fill_1 -prefix FILLER -side w
addIoFiller -cell pad_fill_01 -prefix FILLER -side w
addIoFiller -cell pad_fill_005 -prefix FILLER -side w -fillAnyGap
addRing -type core_rings -follow core -nets {VDD VDD VSS VSS} -center 1 -width {top 10 bottom 10 left 10 right 10} -spacing {top 4 bottom 4 left 4 right 4} -center 1 -layer {top METAL5 bottom METAL5 left METAL6 right METAL6} -use_wire_group 1 -extend_corner {} -jog_distance 0 -snap_wire_center_to_grid None -threshold 0
addStripe -nets {VDD VSS} -layer METAL6 -direction vertical -width 5 -spacing 5 -number_of_sets 10 -start_from left -start_offset 25 -stop_offset 30 -switch_layer_over_obs false -max_same_layer_jog_length 2 -padcore_ring_top_layer_limit METAL6 -padcore_ring_bottom_layer_limit METAL1 -block_ring_top_layer_limit METAL6 -block_ring_bottom_layer_limit METAL1 -use_wire_group 0 -snap_wire_center_to_grid None -skip_via_on_pin {  standardcell } -skip_via_on_wire_shape {  noshape }
addStripe -nets {VDD VSS} -layer METAL5 -direction horizontal -width 5 -spacing 5 -number_of_sets 10 -start_from left -start_offset 30 -stop_offset 30 -switch_layer_over_obs false -max_same_layer_jog_length 2 -padcore_ring_top_layer_limit METAL6 -padcore_ring_bottom_layer_limit METAL1 -block_ring_top_layer_limit METAL6 -block_ring_bottom_layer_limit METAL1 -use_wire_group 0 -snap_wire_center_to_grid None -skip_via_on_pin {  standardcell } -skip_via_on_wire_shape {  noshape }
saveDesign DBS/top_pad-power.enc
sroute -connect { blockPin corePin padPin floatingStripe} -layerChangeRange { METAL1(1) METAL6(6) } -blockPinTarget { nearestTarget } -padPinPortConnect { allPort oneGeom } -padPintarget { nearestTarget } -corePinTarget { firstAfterRowEnd } -crossoverViaLayerRange { METAL1(1) METAL6(6) } -nets { VDD VSS } -allowJogging 1 -allowLayerChange 1 -blockPin useLef -targetViaLayerRange { METAL1(1) METAL6(6)}
fit
saveDesign DBS/top_pad-power-routed.enc
setMultiCpuUsage -localCpu 2 -keepLicense true -acquireLicense 2
setDesignMode -process 180
setDesignMode -topRoutingLayer 4
setPlaceMode -timingDriven true -congEffort high -placeIOPins 1 -place_global_max_density 0.45
place_design
setDrawView place
checkPlace ./RPT/place.rpt
saveDesign DBS/top_pad-placed.enc
setMultiCpuUsage -localCpu 2 -keepLicense true -acquireLicense 2
set_ccopt_property route_type_override_preferred_routing_layer_effort none
setDesignMode -topRoutingLayer 4
setDesignMode -bottomRoutingLayer 2
create_route_type -name clkroute -top_preferred_layer 4
set_ccopt_property route_type clkroute -net_type trunk
set_ccopt_property route_type clkroute -net_type leaf
set_ccopt_property buffer_cells BUFX1
set_ccopt_property inverter_cells {INVX1 INVX2 INVX4 INVX8 INVX16 INVX32}
create_ccopt_clock_tree_spec -file ccopt.spec
get_ccopt_clock_trees
ccopt_check_and_flatten_ilms_no_restore
set_ccopt_property cts_is_sdc_clock_root -pin clk true
create_ccopt_clock_tree -name clk -source clk -no_skew_group
set_ccopt_property clock_period -pin clk 1
set_ccopt_property timing_connectivity_info {}
create_ccopt_skew_group -name clk/constraint -sources clk -auto_sinks
set_ccopt_property include_source_latency -skew_group clk/constraint true
set_ccopt_property extracted_from_clock_name -skew_group clk/constraint clk
set_ccopt_property extracted_from_constraint_mode_name -skew_group clk/constraint constraint
set_ccopt_property extracted_from_delay_corners -skew_group clk/constraint {wc bc}
check_ccopt_clock_tree_convergence
get_ccopt_property auto_design_state_for_ilms
ccopt_design -cts
saveDesign DBS/top_pad-cts.enc
setMultiCpuUsage -localCpu 2 -keepLicense true -acquireLicense 2
setDesignMode -topRoutingLayer 4
setNanoRouteMode -routeWithTimingDriven true -routeTdrEffort 5 -routeWithSiDriven true -drouteFixAntenna true -routeInsertAntennaDiode true -routeAntennaCellName ANTENNA -routeInsertDiodeForClockNets true
routeDesign -globalDetail -wireOpt -viaOpt
saveDesign DBS/top_pad-routed.enc
addFiller -cell {FILL32 FILL16 FILL8 FILL4 FILL2 FILL1} -prefix FILLER
setDrawView place
saveDesign DBS/top_pad-filled.enc
verifyConnectivity -type all -report ./RPT/connectivity.rpt
saveDrc /tmp/innovus_temp_2795254_lab1-30.eng.utah.edu_u1425837_FET4jv/vergQTmp74z26g/qthread_src.drc
clearDrc
saveDrc /tmp/innovus_temp_2795254_lab1-30.eng.utah.edu_u1425837_FET4jv/vergQTmp74z26g/qthread_1.drc
saveDrc /tmp/innovus_temp_2795254_lab1-30.eng.utah.edu_u1425837_FET4jv/vergQTmp74z26g/qthread_0.drc
loadDrc /tmp/innovus_temp_2795254_lab1-30.eng.utah.edu_u1425837_FET4jv/vergQTmp74z26g/qthread.drc
set_verify_drc_mode -check_only regular
verify_drc -report ./RPT/geometry.rpt
verifyProcessAntenna -report ./RPT/antenna.rpt
verifyProcessAntenna -report ./RPT/antenna.rpt
reportNetStat > ./RPT/netlist_stats_final.rpt
report_area > ./RPT/area_final.rpt
report_timing > ${rpt_dir}/timing_final.rpt
summaryReport -noHtml -outfile ./RPT/summary_report.rpt
saveNetlist -includePowerGround -excludeLeafCell ./HDL/PLACED/top_pad_placed_virtuoso.v
saveNetlist -excludeLeafCell ../HDL/PLACED/top_pad_placed_modelsim.v
write_sdf SDF/${design}_placed.sdf
streamOut GDS/top_pad.gds -mapFile /research/ece/lnis-teaching/Designkits/tsmc180nm/pdk/captable/gds2.map -libName DesignLib -structureName top_pad -units 2000 -mode ALL
freeDesign
set init_lef_file { /research/ece/lnis-teaching/Designkits/tsmc180nm/full_custom_lib/lef/tech.lef  /research/ece/lnis-teaching/Designkits/tsmc180nm/full_custom_lib/lef/sclib_tsmc180.lef  /research/ece/lnis-teaching/Designkits/tsmc180nm/full_custom_lib/lef/padlib_tsmc180.lef  /research/ece/lnis-teaching/Designkits/tsmc180nm/full_custom_lib/lef/sclib_tsmc180_antenna.lef  /research/ece/lnis-teaching/Designkits/tsmc180nm/arm_ip/RA1SHD_RD/RA1SHD_RD.vclef  /research/ece/lnis-teaching/Designkits/tsmc180nm/arm_ip/RA1SHD_RD/RA1SHD_RD_ant.lef  /research/ece/lnis-teaching/Designkits/tsmc180nm/arm_ip/RF2SH/RF2SH.vclef  /research/ece/lnis-teaching/Designkits/tsmc180nm/arm_ip/RF2SH/RF2SH_ant.lef }
set init_mmmc_file { CONF/picosoc.view }
set init_verilog { HDL/GATE/top_pad_m.v }
set init_io_file { SCRIPTS/place_io_pad.io }
set init_pwr_net { VDD }
set init_gnd_net { VSS }
init_design
saveDesign DBS/top_pad-import.enc
setDrawView fplan
fit
floorPlan -site core7T -s 1070 910 80 80 80 80
setDrawView fplan
fit
saveDesign DBS/top_pad-fplan.enc
globalNetConnect VDD -type pgpin -pin VDD -all -verbose
globalNetConnect VSS -type pgpin -pin VSS -all -verbose
globalNetConnect VDD -type tiehi
globalNetConnect VSS -type tielo
deleteIoFiller
addIoFiller -cell pad_fill_32 -prefix FILLER -side n
addIoFiller -cell pad_fill_16 -prefix FILLER -side n
addIoFiller -cell pad_fill_8 -prefix FILLER -side n
addIoFiller -cell pad_fill_4 -prefix FILLER -side n
addIoFiller -cell pad_fill_2 -prefix FILLER -side n
addIoFiller -cell pad_fill_1 -prefix FILLER -side n
addIoFiller -cell pad_fill_01 -prefix FILLER -side n
addIoFiller -cell pad_fill_005 -prefix FILLER -side n -fillAnyGap
addIoFiller -cell pad_fill_32 -prefix FILLER -side s
addIoFiller -cell pad_fill_16 -prefix FILLER -side s
addIoFiller -cell pad_fill_8 -prefix FILLER -side s
addIoFiller -cell pad_fill_4 -prefix FILLER -side s
addIoFiller -cell pad_fill_2 -prefix FILLER -side s
addIoFiller -cell pad_fill_1 -prefix FILLER -side s
addIoFiller -cell pad_fill_01 -prefix FILLER -side s
addIoFiller -cell pad_fill_005 -prefix FILLER -side s -fillAnyGap
addIoFiller -cell pad_fill_32 -prefix FILLER -side e
addIoFiller -cell pad_fill_16 -prefix FILLER -side e
addIoFiller -cell pad_fill_8 -prefix FILLER -side e
addIoFiller -cell pad_fill_4 -prefix FILLER -side e
addIoFiller -cell pad_fill_2 -prefix FILLER -side e
addIoFiller -cell pad_fill_1 -prefix FILLER -side e
addIoFiller -cell pad_fill_01 -prefix FILLER -side e
addIoFiller -cell pad_fill_005 -prefix FILLER -side e -fillAnyGap
addIoFiller -cell pad_fill_32 -prefix FILLER -side w
addIoFiller -cell pad_fill_16 -prefix FILLER -side w
addIoFiller -cell pad_fill_8 -prefix FILLER -side w
addIoFiller -cell pad_fill_4 -prefix FILLER -side w
addIoFiller -cell pad_fill_2 -prefix FILLER -side w
addIoFiller -cell pad_fill_1 -prefix FILLER -side w
addIoFiller -cell pad_fill_01 -prefix FILLER -side w
addIoFiller -cell pad_fill_005 -prefix FILLER -side w -fillAnyGap
addRing -type core_rings -follow core -nets {VDD VDD VSS VSS} -center 1 -width {top 10 bottom 10 left 10 right 10} -spacing {top 4 bottom 4 left 4 right 4} -center 1 -layer {top METAL5 bottom METAL5 left METAL6 right METAL6} -use_wire_group 1 -extend_corner {} -jog_distance 0 -snap_wire_center_to_grid None -threshold 0
addStripe -nets {VDD VSS} -layer METAL6 -direction vertical -width 5 -spacing 5 -number_of_sets 10 -start_from left -start_offset 25 -stop_offset 30 -switch_layer_over_obs false -max_same_layer_jog_length 2 -padcore_ring_top_layer_limit METAL6 -padcore_ring_bottom_layer_limit METAL1 -block_ring_top_layer_limit METAL6 -block_ring_bottom_layer_limit METAL1 -use_wire_group 0 -snap_wire_center_to_grid None -skip_via_on_pin {  standardcell } -skip_via_on_wire_shape {  noshape }
addStripe -nets {VDD VSS} -layer METAL5 -direction horizontal -width 5 -spacing 5 -number_of_sets 10 -start_from left -start_offset 30 -stop_offset 30 -switch_layer_over_obs false -max_same_layer_jog_length 2 -padcore_ring_top_layer_limit METAL6 -padcore_ring_bottom_layer_limit METAL1 -block_ring_top_layer_limit METAL6 -block_ring_bottom_layer_limit METAL1 -use_wire_group 0 -snap_wire_center_to_grid None -skip_via_on_pin {  standardcell } -skip_via_on_wire_shape {  noshape }
saveDesign DBS/top_pad-power.enc
sroute -connect { blockPin corePin padPin floatingStripe} -layerChangeRange { METAL1(1) METAL6(6) } -blockPinTarget { nearestTarget } -padPinPortConnect { allPort oneGeom } -padPintarget { nearestTarget } -corePinTarget { firstAfterRowEnd } -crossoverViaLayerRange { METAL1(1) METAL6(6) } -nets { VDD VSS } -allowJogging 1 -allowLayerChange 1 -blockPin useLef -targetViaLayerRange { METAL1(1) METAL6(6)}
fit
saveDesign DBS/top_pad-power-routed.enc
setMultiCpuUsage -localCpu 2 -keepLicense true -acquireLicense 2
setDesignMode -process 180
setDesignMode -topRoutingLayer 4
setPlaceMode -timingDriven true -congEffort high -placeIOPins 1 -place_global_max_density 0.45
place_design
setDrawView place
checkPlace ./RPT/place.rpt
saveDesign DBS/top_pad-placed.enc
setMultiCpuUsage -localCpu 2 -keepLicense true -acquireLicense 2
set_ccopt_property route_type_override_preferred_routing_layer_effort none
setDesignMode -topRoutingLayer 4
setDesignMode -bottomRoutingLayer 2
create_route_type -name clkroute -top_preferred_layer 4
set_ccopt_property route_type clkroute -net_type trunk
set_ccopt_property route_type clkroute -net_type leaf
set_ccopt_property buffer_cells BUFX1
set_ccopt_property inverter_cells {INVX1 INVX2 INVX4 INVX8 INVX16 INVX32}
create_ccopt_clock_tree_spec -file ccopt.spec
get_ccopt_clock_trees
ccopt_check_and_flatten_ilms_no_restore
set_ccopt_property cts_is_sdc_clock_root -pin clk true
create_ccopt_clock_tree -name clk -source clk -no_skew_group
set_ccopt_property clock_period -pin clk 1
set_ccopt_property timing_connectivity_info {}
create_ccopt_skew_group -name clk/constraint -sources clk -auto_sinks
set_ccopt_property include_source_latency -skew_group clk/constraint true
set_ccopt_property extracted_from_clock_name -skew_group clk/constraint clk
set_ccopt_property extracted_from_constraint_mode_name -skew_group clk/constraint constraint
set_ccopt_property extracted_from_delay_corners -skew_group clk/constraint {wc bc}
check_ccopt_clock_tree_convergence
get_ccopt_property auto_design_state_for_ilms
ccopt_design -cts
saveDesign DBS/top_pad-cts.enc
setMultiCpuUsage -localCpu 2 -keepLicense true -acquireLicense 2
setDesignMode -topRoutingLayer 4
setNanoRouteMode -routeWithTimingDriven true -routeTdrEffort 5 -routeWithSiDriven true -drouteFixAntenna true -routeInsertAntennaDiode true -routeAntennaCellName ANTENNA -routeInsertDiodeForClockNets true
routeDesign -globalDetail -wireOpt -viaOpt
saveDesign DBS/top_pad-routed.enc
addFiller -cell {FILL32 FILL16 FILL8 FILL4 FILL2 FILL1} -prefix FILLER
setDrawView place
saveDesign DBS/top_pad-filled.enc
verifyConnectivity -type all -report ./RPT/connectivity.rpt
saveDrc /tmp/innovus_temp_2795254_lab1-30.eng.utah.edu_u1425837_FET4jv/vergQTmpfXW3xv/qthread_src.drc
clearDrc
saveDrc /tmp/innovus_temp_2795254_lab1-30.eng.utah.edu_u1425837_FET4jv/vergQTmpfXW3xv/qthread_1.drc
saveDrc /tmp/innovus_temp_2795254_lab1-30.eng.utah.edu_u1425837_FET4jv/vergQTmpfXW3xv/qthread_0.drc
loadDrc /tmp/innovus_temp_2795254_lab1-30.eng.utah.edu_u1425837_FET4jv/vergQTmpfXW3xv/qthread.drc
set_verify_drc_mode -check_only regular
verify_drc -report ./RPT/geometry.rpt
verifyProcessAntenna -report ./RPT/antenna.rpt
verifyProcessAntenna -report ./RPT/antenna.rpt
reportNetStat > ./RPT/netlist_stats_final.rpt
report_area > ./RPT/area_final.rpt
report_timing > ${rpt_dir}/timing_final.rpt
summaryReport -noHtml -outfile ./RPT/summary_report.rpt
saveNetlist -includePowerGround -excludeLeafCell ./HDL/PLACED/top_pad_placed_virtuoso.v
saveNetlist -excludeLeafCell ../HDL/PLACED/top_pad_placed_modelsim.v
write_sdf SDF/${design}_placed.sdf
streamOut GDS/top_pad.gds -mapFile /research/ece/lnis-teaching/Designkits/tsmc180nm/pdk/captable/gds2.map -libName DesignLib -structureName top_pad -units 2000 -mode ALL
freeDesign
set init_lef_file { /research/ece/lnis-teaching/Designkits/tsmc180nm/full_custom_lib/lef/tech.lef  /research/ece/lnis-teaching/Designkits/tsmc180nm/full_custom_lib/lef/sclib_tsmc180.lef  /research/ece/lnis-teaching/Designkits/tsmc180nm/full_custom_lib/lef/padlib_tsmc180.lef  /research/ece/lnis-teaching/Designkits/tsmc180nm/full_custom_lib/lef/sclib_tsmc180_antenna.lef  /research/ece/lnis-teaching/Designkits/tsmc180nm/arm_ip/RA1SHD_RD/RA1SHD_RD.vclef  /research/ece/lnis-teaching/Designkits/tsmc180nm/arm_ip/RA1SHD_RD/RA1SHD_RD_ant.lef  /research/ece/lnis-teaching/Designkits/tsmc180nm/arm_ip/RF2SH/RF2SH.vclef  /research/ece/lnis-teaching/Designkits/tsmc180nm/arm_ip/RF2SH/RF2SH_ant.lef }
set init_mmmc_file { CONF/picosoc.view }
set init_verilog { HDL/GATE/top_pad_m.v }
set init_io_file { SCRIPTS/place_io_pad.io }
set init_pwr_net { VDD }
set init_gnd_net { VSS }
init_design
saveDesign DBS/top_pad-import.enc
setDrawView fplan
fit
floorPlan -site core7T -s 1070 910 80 80 80 80
setDrawView fplan
fit
saveDesign DBS/top_pad-fplan.enc
globalNetConnect VDD -type pgpin -pin VDD -all -verbose
globalNetConnect VSS -type pgpin -pin VSS -all -verbose
globalNetConnect VDD -type tiehi
globalNetConnect VSS -type tielo
deleteIoFiller
addIoFiller -cell pad_fill_32 -prefix FILLER -side n
addIoFiller -cell pad_fill_16 -prefix FILLER -side n
addIoFiller -cell pad_fill_8 -prefix FILLER -side n
addIoFiller -cell pad_fill_4 -prefix FILLER -side n
addIoFiller -cell pad_fill_2 -prefix FILLER -side n
addIoFiller -cell pad_fill_1 -prefix FILLER -side n
addIoFiller -cell pad_fill_01 -prefix FILLER -side n
addIoFiller -cell pad_fill_005 -prefix FILLER -side n -fillAnyGap
addIoFiller -cell pad_fill_32 -prefix FILLER -side s
addIoFiller -cell pad_fill_16 -prefix FILLER -side s
addIoFiller -cell pad_fill_8 -prefix FILLER -side s
addIoFiller -cell pad_fill_4 -prefix FILLER -side s
addIoFiller -cell pad_fill_2 -prefix FILLER -side s
addIoFiller -cell pad_fill_1 -prefix FILLER -side s
addIoFiller -cell pad_fill_01 -prefix FILLER -side s
addIoFiller -cell pad_fill_005 -prefix FILLER -side s -fillAnyGap
addIoFiller -cell pad_fill_32 -prefix FILLER -side e
addIoFiller -cell pad_fill_16 -prefix FILLER -side e
addIoFiller -cell pad_fill_8 -prefix FILLER -side e
addIoFiller -cell pad_fill_4 -prefix FILLER -side e
addIoFiller -cell pad_fill_2 -prefix FILLER -side e
addIoFiller -cell pad_fill_1 -prefix FILLER -side e
addIoFiller -cell pad_fill_01 -prefix FILLER -side e
addIoFiller -cell pad_fill_005 -prefix FILLER -side e -fillAnyGap
addIoFiller -cell pad_fill_32 -prefix FILLER -side w
addIoFiller -cell pad_fill_16 -prefix FILLER -side w
addIoFiller -cell pad_fill_8 -prefix FILLER -side w
addIoFiller -cell pad_fill_4 -prefix FILLER -side w
addIoFiller -cell pad_fill_2 -prefix FILLER -side w
addIoFiller -cell pad_fill_1 -prefix FILLER -side w
addIoFiller -cell pad_fill_01 -prefix FILLER -side w
addIoFiller -cell pad_fill_005 -prefix FILLER -side w -fillAnyGap
addRing -type core_rings -follow core -nets {VDD VDD VSS VSS} -center 1 -width {top 10 bottom 10 left 10 right 10} -spacing {top 4 bottom 4 left 4 right 4} -center 1 -layer {top METAL5 bottom METAL5 left METAL6 right METAL6} -use_wire_group 1 -extend_corner {} -jog_distance 0 -snap_wire_center_to_grid None -threshold 0
addStripe -nets {VDD VSS} -layer METAL6 -direction vertical -width 5 -spacing 5 -number_of_sets 10 -start_from left -start_offset 25 -stop_offset 30 -switch_layer_over_obs false -max_same_layer_jog_length 2 -padcore_ring_top_layer_limit METAL6 -padcore_ring_bottom_layer_limit METAL1 -block_ring_top_layer_limit METAL6 -block_ring_bottom_layer_limit METAL1 -use_wire_group 0 -snap_wire_center_to_grid None -skip_via_on_pin {  standardcell } -skip_via_on_wire_shape {  noshape }
addStripe -nets {VDD VSS} -layer METAL5 -direction horizontal -width 5 -spacing 5 -number_of_sets 10 -start_from left -start_offset 30 -stop_offset 30 -switch_layer_over_obs false -max_same_layer_jog_length 2 -padcore_ring_top_layer_limit METAL6 -padcore_ring_bottom_layer_limit METAL1 -block_ring_top_layer_limit METAL6 -block_ring_bottom_layer_limit METAL1 -use_wire_group 0 -snap_wire_center_to_grid None -skip_via_on_pin {  standardcell } -skip_via_on_wire_shape {  noshape }
saveDesign DBS/top_pad-power.enc
sroute -connect { blockPin corePin padPin floatingStripe} -layerChangeRange { METAL1(1) METAL6(6) } -blockPinTarget { nearestTarget } -padPinPortConnect { allPort oneGeom } -padPintarget { nearestTarget } -corePinTarget { firstAfterRowEnd } -crossoverViaLayerRange { METAL1(1) METAL6(6) } -nets { VDD VSS } -allowJogging 1 -allowLayerChange 1 -blockPin useLef -targetViaLayerRange { METAL1(1) METAL6(6)}
fit
saveDesign DBS/top_pad-power-routed.enc
setMultiCpuUsage -localCpu 2 -keepLicense true -acquireLicense 2
setDesignMode -process 180
setDesignMode -topRoutingLayer 4
setPlaceMode -timingDriven true -congEffort high -placeIOPins 1 -place_global_max_density 0.45
place_design
setDrawView place
checkPlace ./RPT/place.rpt
saveDesign DBS/top_pad-placed.enc
setMultiCpuUsage -localCpu 2 -keepLicense true -acquireLicense 2
set_ccopt_property route_type_override_preferred_routing_layer_effort none
setDesignMode -topRoutingLayer 4
setDesignMode -bottomRoutingLayer 2
create_route_type -name clkroute -top_preferred_layer 4
set_ccopt_property route_type clkroute -net_type trunk
set_ccopt_property route_type clkroute -net_type leaf
set_ccopt_property buffer_cells BUFX1
set_ccopt_property inverter_cells {INVX1 INVX2 INVX4 INVX8 INVX16 INVX32}
create_ccopt_clock_tree_spec -file ccopt.spec
get_ccopt_clock_trees
ccopt_check_and_flatten_ilms_no_restore
set_ccopt_property cts_is_sdc_clock_root -pin clk true
create_ccopt_clock_tree -name clk -source clk -no_skew_group
set_ccopt_property clock_period -pin clk 1
set_ccopt_property timing_connectivity_info {}
create_ccopt_skew_group -name clk/constraint -sources clk -auto_sinks
set_ccopt_property include_source_latency -skew_group clk/constraint true
set_ccopt_property extracted_from_clock_name -skew_group clk/constraint clk
set_ccopt_property extracted_from_constraint_mode_name -skew_group clk/constraint constraint
set_ccopt_property extracted_from_delay_corners -skew_group clk/constraint {wc bc}
check_ccopt_clock_tree_convergence
get_ccopt_property auto_design_state_for_ilms
ccopt_design -cts
saveDesign DBS/top_pad-cts.enc
setMultiCpuUsage -localCpu 2 -keepLicense true -acquireLicense 2
setDesignMode -topRoutingLayer 4
setNanoRouteMode -routeWithTimingDriven true -routeTdrEffort 5 -routeWithSiDriven true -drouteFixAntenna true -routeInsertAntennaDiode true -routeAntennaCellName ANTENNA -routeInsertDiodeForClockNets true
routeDesign -globalDetail -wireOpt -viaOpt
saveDesign DBS/top_pad-routed.enc
addFiller -cell {FILL32 FILL16 FILL8 FILL4 FILL2 FILL1} -prefix FILLER
setDrawView place
saveDesign DBS/top_pad-filled.enc
verifyConnectivity -type all -report ./RPT/connectivity.rpt
saveDrc /tmp/innovus_temp_2795254_lab1-30.eng.utah.edu_u1425837_FET4jv/vergQTmpkEKzCS/qthread_src.drc
clearDrc
saveDrc /tmp/innovus_temp_2795254_lab1-30.eng.utah.edu_u1425837_FET4jv/vergQTmpkEKzCS/qthread_1.drc
saveDrc /tmp/innovus_temp_2795254_lab1-30.eng.utah.edu_u1425837_FET4jv/vergQTmpkEKzCS/qthread_0.drc
loadDrc /tmp/innovus_temp_2795254_lab1-30.eng.utah.edu_u1425837_FET4jv/vergQTmpkEKzCS/qthread.drc
set_verify_drc_mode -check_only regular
verify_drc -report ./RPT/geometry.rpt
verifyProcessAntenna -report ./RPT/antenna.rpt
verifyProcessAntenna -report ./RPT/antenna.rpt
reportNetStat > ./RPT/netlist_stats_final.rpt
report_area > ./RPT/area_final.rpt
report_timing > ${rpt_dir}/timing_final.rpt
summaryReport -noHtml -outfile ./RPT/summary_report.rpt
saveNetlist -includePowerGround -excludeLeafCell ./HDL/PLACED/top_pad_placed_virtuoso.v
saveNetlist -excludeLeafCell ../HDL/PLACED/top_pad_placed_modelsim.v
write_sdf SDF/${design}_placed.sdf
streamOut GDS/top_pad.gds -mapFile /research/ece/lnis-teaching/Designkits/tsmc180nm/pdk/captable/gds2.map -libName DesignLib -structureName top_pad -units 2000 -mode ALL
redirect -quiet {set honorDomain [getAnalysisMode -honorClockDomains]} > /dev/null
timeDesign -preCTS -pathReports -drvReports -slackReports -numPaths 1 -prefix top_pad_preCTS -outDir RPT
redirect -quiet {set honorDomain [getAnalysisMode -honorClockDomains]} > /dev/null
timeDesign -preCTS -pathReports -drvReports -slackReports -numPaths 1 -prefix top_pad_preCTS -outDir RPT
setLayerPreference node_cell -isVisible 1
setLayerPreference node_cell -isVisible 0
setLayerPreference node_net -isVisible 0
