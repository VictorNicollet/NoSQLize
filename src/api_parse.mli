(* NoSQLize - a public domain NoSQL storage and computation engine. *)

(** Parsing the HTTP request to determine what should be done with it. 
    This forwards the appropriate data to the appropriate function of module
    {!Core} and returns corresponding data to the HTTP daemon.
*)
val parse : 
     uri:string
  -> args:(string * string) list
  -> more:[ `GET | `POST of Json.t | `PUT of Json.t | `DELETE ] 
  -> (int * Json.t) Lwt.t

