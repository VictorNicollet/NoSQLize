(* NoSQLize - a public domain NoSQL storage and computation engine. *)

open Lwt
open BatPervasives
open Driver_types

type id = string

(* Storing all available tables ----------------------------------- *)

module StringT = struct
  type t = id
  let compare = compare
end

module ChangeT = struct
  type t = c_id
  let compare = compare
end

module StringMap = Map.Make(StringT)

module StringTable = Lock.MapLock(StringMap)

module ChangesMap = DualMap.Make(ChangeT)(StringT)

type table = {
  data : Json.t StringTable.t ;
  changes : ChangesMap.t Lock.t
} 

let tables = StringTable.create ()

let make_table () = { 
  data = StringTable.create () ;
  changes = Lock.create ChangesMap.empty
}

let tag_change table id = 
  let cid = change_id (Util.fresh ()) in
  Lock.update (fun c -> ChangesMap.add c cid id) table.changes

(* Implementing the interface ------------------------------------- *)

let fresh () = return (Util.fresh ())

let get tid id = 
  let open StringTable.Sugar in
      return (tables.[tid] 
		 |> BatOption.bind (fun table -> table.data.[id]))

let delete tid id = 
  let open StringTable.Sugar in 
      match tables.[tid] with None -> return () | Some table ->
	match table.data.[id] with 
	  | None   -> return () (* Nothing to delete *)
	  | Some _ -> tag_change table id ; table.data.[id] <- None ; return () 

let set tid id json = 
  let open StringTable.Sugar in
      Lock.update (fun tables -> 
	try let table = StringMap.find tid tables in
	    match table.data.[id] with
	      | Some json' when json = json' -> tables (* Nothing to change *)
	      | _ -> tag_change table id ; table.data.[id] <- Some json ; tables
	with Not_found ->
	  let table = make_table () in
	  tag_change table id ;
	  table.data.[id] <- Some json ;
	  StringMap.add tid table tables
      ) tables ;
      return ()

let put tid id = function
  | None      -> delete tid id
  | Some json -> set    tid id json

let changes tid cidopt = 
  let open StringTable.Sugar in 
      match tables.[tid] with None -> return [] | Some table -> 
	return (ChangesMap.traverse_a (Lock.get table.changes) cidopt None)
