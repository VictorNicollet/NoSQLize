(* NoSQLize - a public domain NoSQL storage and computation engine. *)

(** Utility library. Provides miscellaneous useful functions. *)

(** Explodes an URI. This splits the URI across '/' characters, ignoring
    empty segments. *)
val uri_explode : string -> string list

(** Implodes an URI. This contatenates the URI with '/' characters in-between,
    ignoring empty segments. *)
val uri_implode : string list -> string
