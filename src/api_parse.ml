(* NoSQLize - a public domain NoSQL storage and computation engine. *)

open Lwt

let error text = 
  return (500, `Object [ "error", `String text ])

let get_only more f a = 
  match more with 
    | `GET -> f a
    | _    -> error "Unsupported HTTP method"

let dispatch_root ~args ~more = 
  get_only more Core.status ()

let dispatch_all ~args ~more = 
  get_only more Core.all_databases ()

let dispatch_db db ~args ~more = 
  match more with 
    | `GET    -> Core.get_database db
    | `PUT _  -> Core.put_database db
    | `DELETE -> Core.delete_database db
    | _       -> error "Unsupported HTTP method"

let dispatch_db_all db ~args ~more = 
  error "Not implemented"

let dispatch_db_node db no ~args ~more = 
  error "Not implemented"
 
let dispatch_db_node_id db no id ~args ~more = 
  error "Not implemented"

let parse ~uri ~args ~more = 
  let uri_segments = Util.uri_explode uri in
  match uri_segments with 
    | []               -> dispatch_root                ~args ~more 
    | [ "_all" ]       -> dispatch_all                 ~args ~more
    | [ db ]           -> dispatch_db         db       ~args ~more
    | [ db ; "_all"]   -> dispatch_db_all     db       ~args ~more
    | [ db ; no ]      -> dispatch_db_node    db no    ~args ~more
    | [ db ; no ; id ] -> dispatch_db_node_id db no id ~args ~more
    | _                -> error "Invalid URI"
