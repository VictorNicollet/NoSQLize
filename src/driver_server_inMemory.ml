(* NoSQLize - a public domain NoSQL storage and computation engine. *)

open Lwt
open Driver_types

(* We store all the databases in a locked database map. *)

module D_Id_Map = Map.Make(struct
  type t = d_id
  let compare = compare
end)

module D_Id_Table = Lock.MapLock(D_Id_Map)
 
type database = unit

let databases = D_Id_Table.create () 

(* Processing the requestes *)

let all_databases     () =
  return (D_Id_Map.fold (fun k _ l -> k :: l) (Lock.get databases) [])

let put_database    name =
  let open D_Id_Table.Sugar in
      return (databases.[name] <- Some ())

let get_database    name =
  let open D_Id_Table.Sugar in
      return (databases.[name])
    
let delete_database name = 
  let open D_Id_Table.Sugar in
      return (databases.[name] <- None)
    
