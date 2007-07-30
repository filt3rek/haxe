EXTLIB=../../mtcvs/extlib-dev
SWFLIB=../../mtcvs/swflib
EXTC=../../mtcvs/extc
NEKO=../neko
XML=../../mtcvs/xml-light
LIBS_SRC=$(EXTLIB)/*.ml* -n $(EXTLIB)/install.ml $(SWFLIB)/*.ml* $(EXTC)/extc.ml*
SRC=$(NEKO)/libs/include/ocaml/*.ml* *.ml*
LIBS=unix.cmxa $(XML)/xml-light.cmxa
FLAGS=-o haxe -pp camlp4o -P $(XML)/dtd.mli -lp "-cclib extc_stubs.o -cclib -lz"

all: xml
	ocamlc -c $(EXTC)/extc_stubs.c
	ocamake $(FLAGS) $(LIBS_SRC) $(SRC) $(LIBS)

xml:
	(cd ${XML} && make xml-light.cmxa)

universal: clean_haxe all
	mv haxe haxe.intel
	-scp macmt:prog/lang/haxe/haxe haxe.ppc
	lipo -create -arch i386 haxe.intel -arch ppc haxe.ppc -output haxe
	chmod +x haxe

clean_haxe:
	rm -rf haxe

tools:
	(cd std/tools/haxedoc && haxe haxedoc.hxml && cp haxedoc ../../..)
	(cd std/tools/haxelib && haxe haxelib.hxml && cp haxelib ../../..)

clean:
	ocamake $(FLAGS) -clean $(LIBS_SRC) $(SRC) $(LIBS)
	rm -rf extc_stubs.o
