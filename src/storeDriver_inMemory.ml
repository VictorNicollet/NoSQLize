(* NoSQLize - a public domain NoSQL storage and computation engine. *)

open Lwt
open BatPervasives

type id = string

(* Storing all available tables ----------------------------------- *)

module StringMap = Map.Make(struct
  type t = id
  let compare = compare
end)

module StringTable = Lock.MapLock(StringMap)

type table = {
  data : Json.t StringTable.t
} 

let tables = StringTable.create ()

(* Implementing the interface ------------------------------------- *)

let fresh () = return (Util.fresh ())

let get tid id = 
  let open StringTable.Sugar in
      return (tables.[tid] 
		 |> BatOption.bind (fun table -> table.data.[id]))

let delete tid id = 
  let open StringTable.Sugar in 
      match tables.[tid] with None -> return () | Some table ->
	return (table.data.[id] <- None)

let set tid id json = 
  let open StringTable.Sugar in
      Lock.update (fun tables -> 
	try let table = StringMap.find tid tables in
	    table.data.[id] <- Some json ;
	    tables
	with Not_found ->
	  let table = { data = StringTable.create () } in
	  table.data.[id] <- Some json ;
	  StringMap.add tid table tables
      ) tables ;
      return ()

let put tid id = function
  | None      -> delete tid id
  | Some json -> set    tid id json
