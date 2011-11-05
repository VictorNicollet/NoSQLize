(* NoSQLize - a public domain NoSQL storage and computation engine. *)

let to_string = function `String s -> Some s | _ -> None
let to_integer = function `Int i -> Some i | _ -> None
let to_number = function `Float f -> Some f | `Int i -> Some (float_of_int i) | _ -> None
let to_bool = function `Bool b -> Some b | _ -> None
