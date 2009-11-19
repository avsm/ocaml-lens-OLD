OCAMLMAKEFILE=../OCamlMakefile

.PHONY: run
run: dnc
	./$(RESULT) -verbose

RESULT=run_test
SOURCES=test.ml
ANNOTATE=yes

# to test with built version
INCDIRS=../lib
LIBS=lens
PACKS=unix lwt lwt.unix ounit

-include $(OCAMLMAKEFILE)
