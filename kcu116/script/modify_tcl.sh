
# Add files to project instead of importing (copying) to project directory
sed -i 's/imported_files/added_files/g' bp_fpga.tcl
sed -i 's/file_imported/file_added/g' bp_fpga.tcl
sed -i 's/import_files/add_files/g' bp_fpga.tcl
