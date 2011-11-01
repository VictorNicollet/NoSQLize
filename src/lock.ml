(* NoSQLize - a public domain NoSQL storage and computation engine. *)

open Lwt

type 'a t = {
  mutable value : 'a ;
  lock : Lwt_mutex.t
}

type 'a lock = 'a t

let create value = {
  value ;
  lock = Lwt_mutex.create ()
}

let get t = t.value

let transaction f t = 
  Lwt_mutex.with_lock t.lock 
    (fun () -> f t.value >>= fun v -> return (t.value <- v))

let update f t = 
  t.value <- f t.value

module MapLock = functor(M:Map.S) -> struct

  type key = M.key
  type 'a t = 'a M.t lock

  let create () = create M.empty

  let add t k v = 
    update (M.add k v) t

  let remove t k = 
    update (M.remove k) t

  let set t k = function
    | Some v -> add t k v
    | None   -> remove t k

  let get t k = 
    try Some (M.find k (t.value)) with Not_found -> None

  module Sugar = struct
    module String = struct
      let get = get
      let set = set
    end
  end

end 
