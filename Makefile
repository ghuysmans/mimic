PKG := cmdliner,tyre,lwt.ppx,lwt.unix

all:
	ocamlbuild -use-ocamlfind -package ${PKG} mimic.byte
clean:
	ocamlbuil -clean

.merlin: Makefile
	echo "B _build" >.merlin
	echo "PKG ${PKG}" | sed 's/,/\nPKG /g' >>.merlin
