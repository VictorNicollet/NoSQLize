(* NoSQLize - a public domain NoSQL storage and computation engine. *)

(** This is an in-memnory implementation of the server driver. It can be used in production
    environments as long as persistence of data is not relevant. *)

include Driver.SERVER_DRIVER
