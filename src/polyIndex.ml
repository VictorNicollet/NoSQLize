(* NoSQLize - a public domain NoSQL storage and computation engine. *)

open BatPervasives

type key_type = [ `String | `Int | `Number | `Bool ] list

type id  = string
type key = Json.t list

module IdSet     = Set.Make(struct type t = id            let compare = compare end)
module IdMap     = Map.Make(struct type t = id            let compare = compare end) 
module StringMap = Map.Make(struct type t = string option let compare = compare end)
module IntMap    = Map.Make(struct type t = int    option let compare = compare end)
module FloatMap  = Map.Make(struct type t = float  option let compare = compare end)
module BoolMap   = Map.Make(struct type t = bool   option let compare = compare end)

type store = 
  | StoreId     of IdSet.t
  | StoreString of key_type * (store StringMap.t)
  | StoreInt    of key_type * (store IntMap.t)
  | StoreFloat  of key_type * (store FloatMap.t)
  | StoreBool   of key_type * (store BoolMap.t)

type t = 
    {
      keytype : key_type ;
      store : store ;
      reverse : key IdMap.t ;
    }

let store_empty = function 
  | [] -> StoreId (IdSet.empty)
  | `String :: tail -> StoreString (tail,StringMap.empty)
  | `Int    :: tail -> StoreInt    (tail,IntMap.empty)
  | `Number :: tail -> StoreFloat  (tail,FloatMap.empty)
  | `Bool   :: tail -> StoreBool   (tail,BoolMap.empty)

let empty key_type = {
  keytype = key_type ;
  store = store_empty key_type ;
  reverse = IdMap.empty 
}

(* Define a recursion pattern through the multi-layered map. *)

module MapRecurse = functor (M:Map.S) -> struct

  let step kt map key recurse finish = 
    let current = try M.find key map with Not_found -> store_empty kt in
    let next = match recurse current with 
      | None       -> M.remove key map 
      | Some value -> M.add key value map
    in
    if M.is_empty next then None else Some (finish kt map)

end

module StringRecurse = MapRecurse(StringMap)
module IntRecurse = MapRecurse(IntMap)
module FloatRecurse = MapRecurse(FloatMap)
module BoolRecurse = MapRecurse(BoolMap)

let store_traverse finish recurse key = 
  let head, tail = match key with [] -> `Null, [] | h :: t -> h, t in
  function 
    | StoreId set -> finish set |> BatOption.map (fun set -> StoreId set)
    | StoreString (kt,map) -> 
      StringRecurse.step kt map (JsonType.to_string head) (recurse tail) 
	(fun kt map -> StoreString (kt,map))
    | StoreInt (kt,map) -> 
      IntRecurse.step kt map (JsonType.to_int head) (recurse tail)		     
	(fun kt map -> StoreInt (kt,map))
    | StoreFloat (kt,map) -> 
      FloatRecurse.step kt map (JsonType.to_number head) (recurse tail) 
	(fun kt map -> StoreFloat (kt,map))
    | StoreBool (kt,map) -> 
      BoolRecurse.step kt map (JsonType.to_bool head) (recurse tail) 
	(fun kt map -> StoreBool (kt,map))

(* Use the recursion pattern to define the mutation operations *)



let store_add id key store =
  let add set = Some (IdSet.add id set) in
  let rec aux key store =
    store_traverse add aux key store
  in aux key store 

let rec store_remove id key store =
  let remove set = 
    let set = IdSet.remove id set in 
    if IdSet.is_empty set then None else Some set
  in
  let rec aux key store = 
    store_traverse remove aux key store
  in aux key store


let key_of t id = 
  try Some (IdMap.find id t.reverse) with Not_found -> None

let set t id key = 
  let current = key_of t id in
  if key = current then t else    
    {
      keytype = t.keytype ;
      store = (
	let store =
	  match current with 
	    | None     -> t.store
	    | Some key -> match store_remove id key t.store with
		| Some store -> store
		| None -> store_empty t.keytype 
	in
	match key with
	  | None     -> store 
	  | Some key -> match store_add id key store with 
	      | Some store -> store
	      | None -> store_empty t.keytype 
      ) ;
      reverse = (
	match key with 
	  | None     -> IdMap.remove id t.reverse
	  | Some key -> IdMap.add id key t.reverse
      )
    }

(* Recurse to find a value *)

let rec store_get_all acc = function
  | StoreId set -> IdSet.fold (fun x acc -> x :: acc) set acc
  | StoreString (_,map) -> StringMap.fold (fun _ x acc -> store_get_all acc x) map acc
  | StoreInt    (_,map) -> IntMap.fold    (fun _ x acc -> store_get_all acc x) map acc
  | StoreFloat  (_,map) -> FloatMap.fold  (fun _ x acc -> store_get_all acc x) map acc
  | StoreBool   (_,map) -> BoolMap.fold   (fun _ x acc -> store_get_all acc x) map acc

let rec store_get key store =
  match key with [] -> store_get_all [] store | head :: tail -> 
    match store with 
      | StoreId set -> IdSet.fold (fun x acc -> x :: acc) set []
      | StoreString (_,map) -> store_get tail (StringMap.find (JsonType.to_string head) map)
      | StoreInt    (_,map) -> store_get tail (IntMap.find    (JsonType.to_int    head) map)
      | StoreFloat  (_,map) -> store_get tail (FloatMap.find  (JsonType.to_number head) map)
      | StoreBool   (_,map) -> store_get tail (BoolMap.find   (JsonType.to_bool   head) map)
  
let get t key = 
  try store_get key t.store with Not_found -> []

(* Recurse to count values *)

let rec store_count_all acc = function
  | StoreId set -> acc + IdSet.cardinal set
  | StoreString (_,map) -> StringMap.fold (fun _ x acc -> store_count_all acc x) map acc
  | StoreInt    (_,map) -> IntMap.fold    (fun _ x acc -> store_count_all acc x) map acc
  | StoreFloat  (_,map) -> FloatMap.fold  (fun _ x acc -> store_count_all acc x) map acc
  | StoreBool   (_,map) -> BoolMap.fold   (fun _ x acc -> store_count_all acc x) map acc

let rec store_count key store =
  match key with [] -> store_count_all 0 store | head :: tail -> 
    match store with 
      | StoreId set -> IdSet.cardinal set
      | StoreString (_,map) -> store_count tail (StringMap.find (JsonType.to_string head) map)
      | StoreInt    (_,map) -> store_count tail (IntMap.find    (JsonType.to_int    head) map)
      | StoreFloat  (_,map) -> store_count tail (FloatMap.find  (JsonType.to_number head) map)
      | StoreBool   (_,map) -> store_count tail (BoolMap.find   (JsonType.to_bool   head) map)
  
let count t key = 
  try store_count key t.store with Not_found -> 0
