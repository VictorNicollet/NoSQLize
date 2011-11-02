(* NoSQLize - a public domain NoSQL storage and computation engine. *)

open Driver_types

module type DEFINITION = sig
  type id 
  val fresh : unit -> id Lwt.t
  val put : id -> string -> Json.t option -> unit Lwt.t
  val get : id -> string -> Json.t option Lwt.t
end

