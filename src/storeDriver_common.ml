(* NoSQLize - a public domain NoSQL storage and computation engine. *)

open Driver_types

module type DEFINITION = sig
  type id 
  val fresh : unit -> id Lwt.t
end

