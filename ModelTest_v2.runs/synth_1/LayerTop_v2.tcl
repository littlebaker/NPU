# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
create_project -in_memory -part xc7z035ffg676-2

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir E:/Users/dell/Vivado/ModelTest_v2/ModelTest_v2.cache/wt [current_project]
set_property parent.project_path E:/Users/dell/Vivado/ModelTest_v2/ModelTest_v2.xpr [current_project]
set_property XPM_LIBRARIES XPM_MEMORY [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo e:/Users/dell/Vivado/ModelTest_v2/ModelTest_v2.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files E:/Users/dell/Vivado/ModelTest_v2/conv1.coe
add_files E:/Users/dell/Vivado/ModelTest_v2/conv1input.coe
read_verilog -library xil_defaultlib {
  E:/Users/dell/Vivado/ModelTest_v2/ModelTest_v2.srcs/sources_1/imports/new/ActivePipeline.v
  E:/Users/dell/Vivado/ModelTest_v2/ModelTest_v2.srcs/sources_1/imports/new/ControlPipeline.v
  E:/Users/dell/Vivado/ModelTest_v2/ModelTest_v2.srcs/sources_1/imports/new/ConvLayer.v
  E:/Users/dell/Vivado/ModelTest_v2/ModelTest_v2.srcs/sources_1/imports/new/ConvUnit_v2.v
  E:/Users/dell/Vivado/ModelTest_v2/ModelTest_v2.srcs/sources_1/imports/new/IncreaseBuf.v
  E:/Users/dell/Vivado/ModelTest_v2/ModelTest_v2.srcs/sources_1/imports/new/LoadBlock.v
  E:/Users/dell/Vivado/ModelTest_v2/ModelTest_v2.srcs/sources_1/imports/new/PaddingArray.v
  E:/Users/dell/Vivado/ModelTest_v2/ModelTest_v2.srcs/sources_1/imports/new/PreLoader.v
  E:/Users/dell/Vivado/ModelTest_v2/ModelTest_v2.srcs/sources_1/imports/new/ReluQuantization.v
  E:/Users/dell/Vivado/ModelTest_v2/ModelTest_v2.srcs/sources_1/imports/new/ShiftArray.v
  E:/Users/dell/Vivado/ModelTest_v2/ModelTest_v2.srcs/sources_1/imports/new/ShiftMatrix.v
  E:/Users/dell/Vivado/ModelTest_v2/ModelTest_v2.srcs/sources_1/imports/new/add_unit.v
  E:/Users/dell/Vivado/ModelTest_v2/ModelTest_v2.srcs/sources_1/imports/new/mult_unit_v2.v
  E:/Users/dell/Vivado/ModelTest_v2/ModelTest_v2.srcs/sources_1/imports/new/LayerTop_v2.v
}
read_ip -quiet E:/Users/dell/Vivado/ModelTest_v2/ModelTest_v2.srcs/sources_1/ip/blk_mem_act/blk_mem_act.xci
set_property used_in_implementation false [get_files -all e:/Users/dell/Vivado/ModelTest_v2/ModelTest_v2.srcs/sources_1/ip/blk_mem_act/blk_mem_act_ooc.xdc]

read_ip -quiet E:/Users/dell/Vivado/ModelTest_v2/ModelTest_v2.srcs/sources_1/ip/blk_mem_cl_act_buf/blk_mem_cl_act_buf.xci
set_property used_in_implementation false [get_files -all e:/Users/dell/Vivado/ModelTest_v2/ModelTest_v2.srcs/sources_1/ip/blk_mem_cl_act_buf/blk_mem_cl_act_buf_ooc.xdc]

read_ip -quiet E:/Users/dell/Vivado/ModelTest_v2/ModelTest_v2.srcs/sources_1/ip/blk_mem_cl_kernel_buf/blk_mem_cl_kernel_buf.xci
set_property used_in_implementation false [get_files -all e:/Users/dell/Vivado/ModelTest_v2/ModelTest_v2.srcs/sources_1/ip/blk_mem_cl_kernel_buf/blk_mem_cl_kernel_buf_ooc.xdc]

read_ip -quiet E:/Users/dell/Vivado/ModelTest_v2/ModelTest_v2.srcs/sources_1/ip/blk_mem_increase_buf/blk_mem_increase_buf.xci
set_property used_in_implementation false [get_files -all e:/Users/dell/Vivado/ModelTest_v2/ModelTest_v2.srcs/sources_1/ip/blk_mem_increase_buf/blk_mem_increase_buf_ooc.xdc]

read_ip -quiet E:/Users/dell/Vivado/ModelTest_v2/ModelTest_v2.srcs/sources_1/ip/blk_mem_input_buffer/blk_mem_input_buffer.xci
set_property used_in_implementation false [get_files -all e:/Users/dell/Vivado/ModelTest_v2/ModelTest_v2.srcs/sources_1/ip/blk_mem_input_buffer/blk_mem_input_buffer_ooc.xdc]

read_ip -quiet E:/Users/dell/Vivado/ModelTest_v2/ModelTest_v2.srcs/sources_1/ip/blk_mem_kernel/blk_mem_kernel.xci
set_property used_in_implementation false [get_files -all e:/Users/dell/Vivado/ModelTest_v2/ModelTest_v2.srcs/sources_1/ip/blk_mem_kernel/blk_mem_kernel_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc E:/Users/dell/Vivado/ModelTest_v2/ModelTest_v2.srcs/constrs_1/new/clk.xdc
set_property used_in_implementation false [get_files E:/Users/dell/Vivado/ModelTest_v2/ModelTest_v2.srcs/constrs_1/new/clk.xdc]

set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top LayerTop_v2 -part xc7z035ffg676-2


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef LayerTop_v2.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file LayerTop_v2_utilization_synth.rpt -pb LayerTop_v2_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
