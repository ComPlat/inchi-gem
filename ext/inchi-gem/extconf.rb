require 'fileutils'
require 'rbconfig'
require 'mkmf'

main_dir = File.expand_path(File.join(File.dirname(__FILE__)))
inchi_src = File.join(main_dir, "inchi_src")
libinchi_src = File.join(inchi_src, "INCHI-1-SRC/INCHI_API/libinchi/src")
libinchi_build = File.join(inchi_src, "build")
inchi_version = "d124ee52b4de0ed3d608d2a3d522b939f01f2549"

### Download InChI source
FileUtils.rm_rf inchi_src
Dir.chdir main_dir
system("git clone --no-checkout --filter=tree:0 https://github.com/IUPAC-InChI/InChI.git #{inchi_src}") or abort
Dir.chdir inchi_src
system("git fetch --depth 1 origin #{inchi_version}") or abort
system("git sparse-checkout set --no-cone /INCHI-1-SRC") or abort
system("git checkout #{inchi_version}") or abort

### Compile InChI
system("cmake -B #{libinchi_build} -S #{libinchi_src}") or abort
system("cmake --build #{libinchi_build}") or abort

### Configure Ruby extension
find_library('inchi', "MakeINCHIFromMolfileText", File.join(libinchi_build, "lib"))
find_header('inchi_api.h', File.join(inchi_src, "/INCHI-1-SRC/INCHI_BASE/src"))

Dir.chdir main_dir
create_makefile("inchi")
