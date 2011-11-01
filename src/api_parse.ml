(* NoSQLize - a public domain NoSQL storage and computation engine. *)

open Lwt

let error text = 
  return (500, `Object [ "error", `String text ])

let dispatch_root ~args ~more = 
  error "Not implemented"

let dispatch_all ~args ~more = 
  error "Not implemented"

let dispatch_db db ~args ~more = 
  error "Not implemented"

let dispatch_db_all db ~args ~more = 
  error "Not implemented"

let dispatch_db_store db store ~args ~more = 
  error "Not implemented"
 
let dispatch_db_store_id db store id ~args ~more = 
  error "Not implemented"

let parse ~uri ~args ~more = 
  let uri_segments = Util.uri_explode uri in
  match uri_segments with 
    | []                  -> dispatch_root                    ~args ~more 
    | [ "_all" ]          -> dispatch_all                     ~args ~more
    | [ db ]              -> dispatch_db          db          ~args ~more
    | [ db ; "_all"]      -> dispatch_db_all      db          ~args ~more
    | [ db ; store ]      -> dispatch_db_store    db store    ~args ~more
    | [ db ; store ; id ] -> dispatch_db_store_id db store id ~args ~more
    | _                   -> error "Invalid URI"
