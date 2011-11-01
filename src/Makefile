FLAGS = \
	-ocamlopt 'ocamlfind ocamlopt -syntax camlp4o -package lwt.syntax -linkpkg -package lwt -package http -package batteries -thread' \
	-ocamlc   'ocamlfind ocamlc   -syntax camlp4o -package lwt.syntax -linkpkg -package lwt -package http -package batteries -thread'

all:
	ocamlbuild $(FLAGS) NoSQLize.native

clean:
	ocamlbuild -clean