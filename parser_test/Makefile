OCAMLMAKEFILE=../OCamlMakefile

.PHONY: run
run: dnc
	./$(RESULT) -verbose

RESULT=run_test
SOURCES=test.ml
ANNOTATE=yes

# to test with built version
INCDIRS=../lib ../parser
LIBS=lens parser
PACKS=unix lwt lwt.unix ounit value

-include $(OCAMLMAKEFILE)
