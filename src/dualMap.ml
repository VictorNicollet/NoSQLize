(* NoSQLize - a public domain NoSQL storage and computation engine. *)

module type OrderedType = Map.OrderedType

module type S = sig
  type a 
  type b
  type t 
  val empty : t
  val mem : t -> a -> b -> bool
  val find_b : t -> a -> b option
  val find_a : t -> b -> a option 
  val add : t -> a -> b -> t 
  val remove_a : t -> a -> t
  val remove_b : t -> b -> t
  val traverse_a : t -> a option -> a option -> (a * b) list
  val traverse_b : t -> b option -> b option -> (a * b) list 
end

module Make =
  functor (A:OrderedType) ->
    functor (B:OrderedType) ->
struct

  (* Elementary type & module definitions *)
  type a = A.t
  type b = B.t
  module AMap = Map.Make(A)
  module BMap = Map.Make(B)
  type t = b AMap.t * a BMap.t

  (* Simple operations that do not require symmetrical behavior *)
  let empty = (AMap.empty,BMap.empty)
    
  let mem (ma,_) a b = try b = AMap.find a ma with Not_found -> false

  let find_b (ma,_) a = try Some (AMap.find a ma) with Not_found -> None
  let find_a (_,mb) b = try Some (BMap.find b mb) with Not_found -> None

  let add (ma,mb) a b = 
    
    let ma' = 
      try let a' = BMap.find b mb in
	  AMap.remove a' ma
      with Not_found -> ma
    in

    let mb' =
      try let b' = AMap.find a ma in
	  BMap.remove b' mb
      with Not_found -> mb
    in

    AMap.add a b ma', BMap.add b a mb'
      
  (* Removal is acually a fairly symmetric relationship. *)
  let certain_remove (ma,mb) a b =    
    (* This function assumes that the pair (a,b) is in the dual map. 
       It will cause painful behavior if it is not. *)
    AMap.remove a ma, BMap.remove b mb

  let remove_a (ma,mb) a = 
    try certain_remove (ma,mb) a (AMap.find a ma)
    with Not_found -> (ma,mb)

  let remove_b (ma,mb) b = 
    try certain_remove (ma,mb) (BMap.find b mb) b
    with Not_found -> (ma,mb)

  (* Traversal only needs a splitting function, an enumeration function
     and a post-processing function. *)
  let traverse key1 key2 split enumerate postprocess map = 

    let first, map = match key1 with None -> None, map | Some k ->
      let (_,first,rest) = split k map in
      BatOption.map (fun v -> k,v) first, rest
    in

    let last, map = match key2 with None -> None, map | Some k -> 
      let (rest,last,_) = split k map in
      BatOption.map (fun v -> k,v) last, rest
    in
    
    let init = 
      match first with None -> [] | Some (k,v) -> [ postprocess k v ]
    in

    let folded = 
      enumerate (fun k v acc -> postprocess k v :: acc) map init 
    in

    let final = 
      match last with None -> folded | Some (k,v) -> postprocess k v :: folded
    in

    List.rev final

  let traverse_a (ma,_) a1 a2 = 
    traverse a1 a2 AMap.split AMap.fold (fun a b -> a,b) ma

  let traverse_b (_,mb) b1 b2 = 
    traverse b1 b2 BMap.split BMap.fold (fun b a -> a,b) mb

end


