proc gen_dtb {hdf} {
   hsi::open_hw_design $hdf
   hsi::set_repo_path ./repo
   hsi::create_sw_design device-tree -os device_tree -proc psu_cortexa53_0
   hsi::generate_target -dir my_dts
}

gen_dtb vivado_export/ULTRA96V2_wrapper.xsa
