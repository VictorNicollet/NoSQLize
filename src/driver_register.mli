(* NoSQLize - a public domain NoSQL storage and computation engine. *)

(** This module exports nothing. Internally, it registers all drivers. Make sure that 
    at least one module on the general path (such as the core module) will 
    [open Driver_register] or else the drivers will not be registered. 
*)
