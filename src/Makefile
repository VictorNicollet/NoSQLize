FLAGS = \
	-ocamlopt 'ocamlfind ocamlopt -syntax camlp4o -package lwt.syntax -linkpkg -package lwt -package http' \
	-ocamlc   'ocamlfind ocamlc   -syntax camlp4o -package lwt.syntax -linkpkg -package lwt -package http'

all:
	ocamlbuild $(FLAGS) NoSQLize.native

clean:
	ocamlbuild -clean