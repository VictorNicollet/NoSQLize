{
(* NoSQLize - a public domain NoSQL storage and computation engine. *)

type path = [ `Keep 
	    | `Go of string * path 
	    | `TakeAndGo of path * path ]

exception Unexpected of char option
}

let whitespace = [' ' '\n' '\t' '\r']
let identifier = ['A'-'Z' 'a'-'z' '_'] ['A'-'Z' 'a'-'z' '_' '0'-'9'] *

rule extract = parse
  "\xEF\xBB\xBF" { extract lexbuf } 
| whitespace+ { extract lexbuf }
| '.' whitespace* (identifier as id) { `Go (id,extract lexbuf) }
| '[' { let sub = subextract lexbuf in `TakeAndGo (sub,extract lexbuf) } 
| _ as c { raise (Unexpected (Some c)) }
| eof { `Keep } 

and subextract = parse
| whitespace+ { subextract lexbuf }  
| '.' whitespace* (identifier as id) { `Go (id,subextract lexbuf) }
| '[' { let sub = subextract lexbuf in `TakeAndGo (sub, subextract lexbuf) }
| ']' { `Keep }
| _ as c { raise (Unexpected (Some c)) } 
| eof { raise (Unexpected None)}
