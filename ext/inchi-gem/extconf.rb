require 'fileutils'
require 'rbconfig'
require 'mkmf'

# current dir
main_dir = File.expand_path(File.join(File.dirname(__FILE__)))

# ext/inchi-gem/inchi
inchi_src_dir = File.join(main_dir, "inchi")

FileUtils.rm_rf inchi_src_dir

Dir.chdir main_dir
puts "Downloading InChI sources"
# ext/inchi-gem/inchi/
system "git clone https://github.com/CamAnNguyen/inchi" or abort

# ext/inchi-gem/inchi/INCHI_BASE/src -> inchi-gem/build/inchi/INCHI_API/libinchi/src
FileUtils.cp_r("#{inchi_src_dir}/INCHI_BASE/src/.", "#{inchi_src_dir}/INCHI_API/libinchi/src")

inc_dirs = '-I. -I./inchi/INCHI_API/libinchi/src'

system("swig #{inc_dirs} -c++ -ruby inchi.i") or abort

$INCFLAGS << inc_dirs
$CFLAGS << " -DTARGET_API_LIB"

$srcs = [
  'inchi.cpp',
  'inchi_wrap.cxx',
  './inchi/INCHI_API/libinchi/src/ichi_bns.c',
  './inchi/INCHI_API/libinchi/src/ichi_io.c',
  './inchi/INCHI_API/libinchi/src/ichican2.c',
  './inchi/INCHI_API/libinchi/src/ichicano.c',
  './inchi/INCHI_API/libinchi/src/ichicans.c',
  './inchi/INCHI_API/libinchi/src/ichierr.c',
  './inchi/INCHI_API/libinchi/src/ichiisot.c',
  './inchi/INCHI_API/libinchi/src/ichilnct.c',
  './inchi/INCHI_API/libinchi/src/ichimak2.c',
  './inchi/INCHI_API/libinchi/src/ichimake.c',
  './inchi/INCHI_API/libinchi/src/ichimap1.c',
  './inchi/INCHI_API/libinchi/src/ichimap2.c',
  './inchi/INCHI_API/libinchi/src/ichimap4.c',
  './inchi/INCHI_API/libinchi/src/ichinorm.c',
  './inchi/INCHI_API/libinchi/src/ichiparm.c',
  './inchi/INCHI_API/libinchi/src/ichiprt1.c',
  './inchi/INCHI_API/libinchi/src/ichiprt2.c',
  './inchi/INCHI_API/libinchi/src/ichiprt3.c',
  './inchi/INCHI_API/libinchi/src/ichiqueu.c',
  './inchi/INCHI_API/libinchi/src/ichiread.c',
  './inchi/INCHI_API/libinchi/src/ichiring.c',
  './inchi/INCHI_API/libinchi/src/ichirvr1.c',
  './inchi/INCHI_API/libinchi/src/ichirvr2.c',
  './inchi/INCHI_API/libinchi/src/ichirvr3.c',
  './inchi/INCHI_API/libinchi/src/ichirvr4.c',
  './inchi/INCHI_API/libinchi/src/ichirvr5.c',
  './inchi/INCHI_API/libinchi/src/ichirvr6.c',
  './inchi/INCHI_API/libinchi/src/ichirvr7.c',
  './inchi/INCHI_API/libinchi/src/ichisort.c',
  './inchi/INCHI_API/libinchi/src/ichister.c',
  './inchi/INCHI_API/libinchi/src/ichitaut.c',
  './inchi/INCHI_API/libinchi/src/ikey_base26.c',
  './inchi/INCHI_API/libinchi/src/ikey_dll.c',
  './inchi/INCHI_API/libinchi/src/inchi_dll.c',
  './inchi/INCHI_API/libinchi/src/inchi_dll_a.c',
  './inchi/INCHI_API/libinchi/src/inchi_dll_a2.c',
  './inchi/INCHI_API/libinchi/src/inchi_dll_b.c',
  './inchi/INCHI_API/libinchi/src/inchi_dll_main.c',
  './inchi/INCHI_API/libinchi/src/inchi_gui.c',
  './inchi/INCHI_API/libinchi/src/mol2atom.c',
  './inchi/INCHI_API/libinchi/src/mol_fmt1.c',
  './inchi/INCHI_API/libinchi/src/mol_fmt2.c',
  './inchi/INCHI_API/libinchi/src/mol_fmt3.c',
  './inchi/INCHI_API/libinchi/src/mol_fmt4.c',
  './inchi/INCHI_API/libinchi/src/readinch.c',
  './inchi/INCHI_API/libinchi/src/runichi.c',
  './inchi/INCHI_API/libinchi/src/runichi2.c',
  './inchi/INCHI_API/libinchi/src/runichi3.c',
  './inchi/INCHI_API/libinchi/src/runichi4.c',
  './inchi/INCHI_API/libinchi/src/sha2.c',
  './inchi/INCHI_API/libinchi/src/strutil.c',
  './inchi/INCHI_API/libinchi/src/util.c',
  './inchi/INCHI_API/libinchi/src/ixa/ixa_builder.c',
  './inchi/INCHI_API/libinchi/src/ixa/ixa_inchikey_builder.c',
  './inchi/INCHI_API/libinchi/src/ixa/ixa_mol.c',
  './inchi/INCHI_API/libinchi/src/ixa/ixa_read_inchi.c',
  './inchi/INCHI_API/libinchi/src/ixa/ixa_read_mol.c',
  './inchi/INCHI_API/libinchi/src/ixa/ixa_status.c',
]

$objs = [
  'inchi.o',
  'inchi_wrap.o',
  './inchi/INCHI_API/libinchi/src/ichi_bns.o',
  './inchi/INCHI_API/libinchi/src/ichi_io.o',
  './inchi/INCHI_API/libinchi/src/ichican2.o',
  './inchi/INCHI_API/libinchi/src/ichicano.o',
  './inchi/INCHI_API/libinchi/src/ichicans.o',
  './inchi/INCHI_API/libinchi/src/ichierr.o',
  './inchi/INCHI_API/libinchi/src/ichiisot.o',
  './inchi/INCHI_API/libinchi/src/ichilnct.o',
  './inchi/INCHI_API/libinchi/src/ichimak2.o',
  './inchi/INCHI_API/libinchi/src/ichimake.o',
  './inchi/INCHI_API/libinchi/src/ichimap1.o',
  './inchi/INCHI_API/libinchi/src/ichimap2.o',
  './inchi/INCHI_API/libinchi/src/ichimap4.o',
  './inchi/INCHI_API/libinchi/src/ichinorm.o',
  './inchi/INCHI_API/libinchi/src/ichiparm.o',
  './inchi/INCHI_API/libinchi/src/ichiprt1.o',
  './inchi/INCHI_API/libinchi/src/ichiprt2.o',
  './inchi/INCHI_API/libinchi/src/ichiprt3.o',
  './inchi/INCHI_API/libinchi/src/ichiqueu.o',
  './inchi/INCHI_API/libinchi/src/ichiread.o',
  './inchi/INCHI_API/libinchi/src/ichiring.o',
  './inchi/INCHI_API/libinchi/src/ichirvr1.o',
  './inchi/INCHI_API/libinchi/src/ichirvr2.o',
  './inchi/INCHI_API/libinchi/src/ichirvr3.o',
  './inchi/INCHI_API/libinchi/src/ichirvr4.o',
  './inchi/INCHI_API/libinchi/src/ichirvr5.o',
  './inchi/INCHI_API/libinchi/src/ichirvr6.o',
  './inchi/INCHI_API/libinchi/src/ichirvr7.o',
  './inchi/INCHI_API/libinchi/src/ichisort.o',
  './inchi/INCHI_API/libinchi/src/ichister.o',
  './inchi/INCHI_API/libinchi/src/ichitaut.o',
  './inchi/INCHI_API/libinchi/src/ikey_base26.o',
  './inchi/INCHI_API/libinchi/src/ikey_dll.o',
  './inchi/INCHI_API/libinchi/src/inchi_dll.o',
  './inchi/INCHI_API/libinchi/src/inchi_dll_a.o',
  './inchi/INCHI_API/libinchi/src/inchi_dll_a2.o',
  './inchi/INCHI_API/libinchi/src/inchi_dll_b.o',
  './inchi/INCHI_API/libinchi/src/inchi_dll_main.o',
  './inchi/INCHI_API/libinchi/src/inchi_gui.o',
  './inchi/INCHI_API/libinchi/src/mol2atom.o',
  './inchi/INCHI_API/libinchi/src/mol_fmt1.o',
  './inchi/INCHI_API/libinchi/src/mol_fmt2.o',
  './inchi/INCHI_API/libinchi/src/mol_fmt3.o',
  './inchi/INCHI_API/libinchi/src/mol_fmt4.o',
  './inchi/INCHI_API/libinchi/src/readinch.o',
  './inchi/INCHI_API/libinchi/src/runichi.o',
  './inchi/INCHI_API/libinchi/src/runichi2.o',
  './inchi/INCHI_API/libinchi/src/runichi3.o',
  './inchi/INCHI_API/libinchi/src/runichi4.o',
  './inchi/INCHI_API/libinchi/src/sha2.o',
  './inchi/INCHI_API/libinchi/src/strutil.o',
  './inchi/INCHI_API/libinchi/src/util.o',
  './inchi/INCHI_API/libinchi/src/ixa/ixa_builder.o',
  './inchi/INCHI_API/libinchi/src/ixa/ixa_inchikey_builder.o',
  './inchi/INCHI_API/libinchi/src/ixa/ixa_mol.o',
  './inchi/INCHI_API/libinchi/src/ixa/ixa_read_inchi.o',
  './inchi/INCHI_API/libinchi/src/ixa/ixa_read_mol.o',
  './inchi/INCHI_API/libinchi/src/ixa/ixa_status.o',
]

create_makefile('inchi')
