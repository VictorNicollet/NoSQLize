(* NoSQLize - a public domain NoSQL storage and computation engine. *)

open Lwt

let parse ~uri ~args ~more = 
  let _ = Util.uri_explode uri in
  return (500,`Null)
