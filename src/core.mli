(* NoSQLize - a public domain NoSQL storage and computation engine. *)

(** The core API of the NoSQLize node. These functions perform simple operations 
    as standalone threads. *)

(** Return the current status of the node. *)
val status : unit -> (int * Json.t) Lwt.t

(** Returns the list of names of all databases. *)
val all_databases : unit -> (int * Json.t) Lwt.t

(** Returns the information for one database, if it exists. *)
val get_database : string -> (int * Json.t) Lwt.t

(** Creates a database if it does not already exist. *)
val put_database : string -> (int * Json.t) Lwt.t

(** Deletes a database. *)
val delete_database : string -> (int * Json.t) Lwt.t

(** Get the names of all nodes in a database. *)
val all_nodes : string -> (int * Json.t) Lwt.t

(** Get the properties of a node. *)
val get_node : string -> string -> (int * Json.t) Lwt.t

(** Create or update a node. *)
val put_node : string -> string -> Json.t -> (int * Json.t) Lwt.t

(** Delete a node. *)
val delete_node : string -> string -> (int * Json.t) Lwt.t

(** Get an item from a node. *)
val get_item : string -> string -> string -> (int * Json.t) Lwt.t

(** Put an item in a node. *)
val put_item : string -> string -> string -> Json.t -> (int * Json.t) Lwt.t

(** Delete an item from a node. *)
val delete_item : string -> string -> string -> (int * Json.t) Lwt.t

(** The list of changes on a node (since a certain date) *)
val node_changes : string -> string -> string option -> (int * Json.t) Lwt.t

