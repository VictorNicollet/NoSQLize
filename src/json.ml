(* NoSQLIze - a public domain NoSQL storage and computation engine. *)

type t = Json_type.t

let json_of_string string = 
  let lexbuf = Lexing.from_string string in
  try Json_lex.value lexbuf 
  with _ -> let s = String.sub
	      lexbuf.Lexing.lex_buffer
	      lexbuf.Lexing.lex_start_pos
	      (String.length lexbuf.Lexing.lex_buffer - lexbuf.Lexing.lex_start_pos)
	    in
	    raise (Json_lex.unexpected s)

let string_of_json json = 
  let buffer = Buffer.create 1024 in
  let rec value = function 
    | `String s   -> string s
    | `Null       -> Buffer.add_string buffer "null"
    | `Bool true  -> Buffer.add_string buffer "true"
    | `Bool false -> Buffer.add_string buffer "false"
    | `Int i      -> Buffer.add_string buffer (string_of_int i) 
    | `Float f    -> let f = string_of_float f in 
			      if f.[String.length f - 1] = '.' then 			      
				Buffer.add_substring buffer f 0 (String.length f - 1) 
			      else
				Buffer.add_string buffer f 
    | `Array []   -> Buffer.add_string buffer "[]"
    | `Object []  -> Buffer.add_string buffer "{}"

    | `Array (h :: t) -> 
      Buffer.add_char buffer '[' ;
      value h ;
      List.iter (fun x -> Buffer.add_char buffer ',' ; value x) t ;
      Buffer.add_char buffer ']' 

    | `Object (h :: t) -> 
      Buffer.add_char buffer '{' ;
      pair h ;
      List.iter (fun x -> Buffer.add_char buffer ',' ; pair x) t ;
      Buffer.add_char buffer '}'
  and pair (k,v) = 
    string k ;
    Buffer.add_char buffer ':' ;
    value v 
  and string s = 
    Buffer.add_char buffer '"' ;
    clean s 0 0 (String.length s);
    Buffer.add_char buffer '"'
  and clean s prev n m = 
    if m = n then
      if prev < n then Buffer.add_substring buffer s prev (n-prev) else ()
    else 
      match s.[n] with    
	| '\"' ->
	  if prev < n then Buffer.add_substring buffer s prev (n-prev) ;
	  Buffer.add_string buffer "\\\"" ;
	  clean s (n+1) (n+1) m
	| '\n' ->
	  if prev < n then Buffer.add_substring buffer s prev (n-prev) ;
	  Buffer.add_string buffer "\\n" ;
	  clean s (n+1) (n+1) m
	| '\b' ->
	  if prev < n then Buffer.add_substring buffer s prev (n-prev) ;
	  Buffer.add_string buffer "\\b" ;
	  clean s (n+1) (n+1) m
	| '\t' ->
	  if prev < n then Buffer.add_substring buffer s prev (n-prev) ;
	  Buffer.add_string buffer "\\t" ;
	  clean s (n+1) (n+1) m
	| '\r' ->
	  if prev < n then Buffer.add_substring buffer s prev (n-prev) ;
	  Buffer.add_string buffer "\\r" ;
	  clean s (n+1) (n+1) m
	| '\\' ->
	  if prev < n then Buffer.add_substring buffer s prev (n-prev) ;
	  Buffer.add_string buffer "\\\\" ;
	  clean s (n+1) (n+1) m
	| _ -> clean s prev (n+1) m
  in

  value json ;
  Buffer.contents buffer
