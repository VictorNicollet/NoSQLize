(* NoSQLize - a public domain NoSQL storage and computation engine. *)

open Lwt

let fail code text =
  return (code, `Object [ "error", `String text ])

let error  text = fail 500 text
let unsupported = fail 405 "Unsupported HTTP method" 

let get_only more f a = 
  match more with 
    | `GET -> f a
    | _    -> unsupported

let dispatch_root ~args ~more = 
  get_only more Core.status ()

let dispatch_all ~args ~more = 
  get_only more Core.all_databases ()

let dispatch_db db ~args ~more = 
  match more with 
    | `GET    -> Core.get_database db
    | `PUT _  -> Core.put_database db
    | `DELETE -> Core.delete_database db
    | _       -> unsupported

let dispatch_db_all db ~args ~more = 
  get_only more Core.all_nodes db

let dispatch_db_node db no ~args ~more = 
  match more with 
    | `GET     -> Core.get_node db no
    | `PUT put -> Core.put_node db no put
    | `DELETE  -> Core.delete_node db no
    | _        -> error "Not implemented" 
 
let dispatch_db_node_id db no id ~args ~more = 
  match more with 
    | `GET     -> Core.get_item db no id
    | `PUT put -> Core.put_item db no id put
    | `DELETE  -> Core.delete_item db no id 
    | _        -> unsupported

let dispatch_db_node_changes db no ~args ~more = 
  get_only more (Core.node_changes db no)
    (try Some (List.assoc "since" args) with _ -> None)

let parse ~uri ~args ~more = 
  let uri_segments = Util.uri_explode uri in
  match uri_segments with 
    | []                       -> dispatch_root                     ~args ~more 
    | [ "!all" ]               -> dispatch_all                      ~args ~more
    | [ db ]                   -> dispatch_db              db       ~args ~more
    | [ db ; "!all"]           -> dispatch_db_all          db       ~args ~more
    | [ db ; no ]              -> dispatch_db_node         db no    ~args ~more
    | [ db ; no ; "!changes" ] -> dispatch_db_node_changes db no    ~args ~more
    | [ db ; no ; id ]         -> dispatch_db_node_id      db no id ~args ~more
    | _                        -> fail 404 "Invalid URI"
