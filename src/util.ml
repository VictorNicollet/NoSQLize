(* NoSQLize - a public domain NoSQL storage and computation engine. *)

let uri_explode string = 
  List.filter (fun x -> x <> "")
    (BatString.nsplit string "/")

let uri_implode list = 
  String.concat "/"
    (List.filter (fun x -> x <> "") list)
