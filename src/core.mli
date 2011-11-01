(* NoSQLIze - a public domain NoSQL storage and computation engine. *)

(** Process a get-request. *)
val get  : string -> (string * string) list -> (int * Json.t) Lwt.t

(** Process a post-request. *)
val post : string -> (string * string) list -> Json.t -> (int * Json.t) Lwt.t 
