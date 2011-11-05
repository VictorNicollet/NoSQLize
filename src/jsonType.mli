(* NoSQLize - a public domain NoSQL storage and computation engine. *)

(** Force basic types out of JSON values. *)

(** Return the value as a string. Non-string values are returned as None. *)
val to_string : Json.t -> string option

(** Return the value as an integer. Non-integer values are returned as None. *)
val to_integer : Json.t -> int option

(** Return the value as a floating point number. Integer values are transformed into
    floating-point values and returned. Other values are returned as None. *)
val to_number : Json.t -> float option

(** Return the value as a boolean. Non-booleans are returned a None. *)
val to_bool : Json.t -> bool option
