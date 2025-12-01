#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Sun Nov 30 20:40:40 2025                
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
saveDesign DBS/soc_top-import.enc
setDrawView fplan
fit
floorPlan -site core7T -s 1070 910 80 80 80 80
setDrawView fplan
fit
placeInstance soc/soc_memory_sram_2 318 315 R180
