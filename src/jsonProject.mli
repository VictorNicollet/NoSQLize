(* NoSQLize - a public domain NoSQL storage and computation engine. *)

(** JSON projection: a simple way to reach into a JSON object using only
    member access operations in order to extract a value. 

    Typical examples: {[
.name
.friends.length
.friends[.bestfriend].name 
    ]}
*)

(** The type of a path extraction operator. Construct with {!Build} or {!parse}, 
    use with {!apply} *)
type t 

(** A parser error, indicates the character with a problem ([None] for unexpected
    end of file. *)
exception Unexpected of char option

(** A builder module. Helps build JSON projection operators with a clean syntax:

    {[
compile (doc |> get "name")
compile (doc |> get "friends" |> get "length")
compile (doc |> get "friends" |> at (doc |> get "bestfriend") |> get "name")
    ]}
*)
module Build : sig 

  (** An intermediary type for building. *)
  type builder
     
  (** A builder that extracts the document root itself. *)
  val doc : builder 

  (** Compile a builder into a projection operator. *)
  val compile : builder -> t 

  (** Dive into a document by fetching a certain member. For instance, 
      {[
foobar.themember
      ]}
      is constructed with:
      {[
foobar |> get "themember"
      ]}
  *)
  val get : string -> builder -> builder

  (** Dive into a document by fecthing a dynamic value. For instance,
      {[
foobar[projector] 
      ]}
      is constructed with:
      {[
foobar |> at projector
      ]}
  *)
  val at : builder -> builder -> builder

end

(** Parse a projector represented as a string. The syntax is fairly simple:

    {[
PROJECTOR := eof
           | . IDENTIFIER PROJECTOR
           | [ PROJECTOR ] PROJECTOR
    ]}

    Identifiers must start with a letter or underscore and only contain letters,
    underscores and digits. 
    @raise Unexpected if an unexpected character or EOF is found.
*)
val parse : string -> t 

(** Apply a projector to a JSON value. Returns the projected JSON value. 
    Note that any member access which does not make semantic sense will
    return [`Null], that objects are string-keyed and arrays are integer-keyed, 
    and that the only non-integer key on arrays is [length].
*) 
val apply : Json.t -> t -> Json.t


