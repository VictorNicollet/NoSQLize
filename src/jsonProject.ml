(* NoSQLize - a public domain NoSQL storage and computation engine. *)

type t = JsonProject_lex.path

exception Unexpected of char option

module Build = struct

  type builder = t -> t 
      
  let doc t = t
  let compile builder = builder `Keep 
  let get name builder t = builder (`Go (name,t))
  let at inner builder t = builder (`TakeAndGo (compile inner, t))

end

let parse string =  
  let lexbuf = Lexing.from_string string in
  try JsonProject_lex.extract lexbuf 
  with JsonProject_lex.Unexpected c -> raise (Unexpected c)

let apply doc t = 
  let assoc k l = try List.assoc k l with Not_found -> `Null in
  let at i l = try List.nth l i with _ -> `Null in
  let rec aux = function
    | `Keep, any -> any 
    | `Go (member,sub), `Object obj -> aux (sub,assoc member obj) 
    | `Go _, _ -> `Null
    | `TakeAndGo (inner,sub), `Object obj -> 
      (match aux (inner,doc) with
	| `String s -> aux (sub,assoc s obj)
	| _ -> aux (sub,`Null))
    | `TakeAndGo (inner,sub), `Array a -> 
      (match aux (inner,doc) with
	| `Int i -> aux (sub,at i a)
	| `String "length" -> aux (sub, `Int (List.length a))
	| _ -> aux (sub, `Null))
    | `TakeAndGo _, _ -> `Null
  in aux (t,doc)
