(* NoSQLize - a public domain NoSQL storage and computation engine. *)

open Lwt

let channel : (unit -> unit Lwt.t) Event.channel = Event.new_channel ()

(* This counter increments when workers start and decrements when 
   workers return. It does not handle exceptions, which should be 
   fixed. *)
let worker_count = ref 0

let with_worker task = 
  incr worker_count ; 
  task () >>= fun () -> return (decr worker_count)

(* This loop is executed by the Lwt worker, it polls the incoming task channel
   for tasks and runs them. The loop structure is designed so that all the 
   pending events are extracted in one go and joined together with <&> before
   their execution starts. *)
let rec loop () = 
  Thread.yield () ;
  match Event.poll (Event.receive channel) with 
    | Some act -> with_worker act <&> loop ()
    | None     -> Lwt_unix.yield () >>= loop  

let _ = Thread.create Lwt_main.run (loop ())

let delegate f x = 
  (* Encapsulates the 'return value to original thread' operation as an
     unit-returning Lwt.t *)
  let back   = Event.new_channel () in
  let act () = f x >>= fun y -> return (Event.sync (Event.send back y)) in
  let ()     = Event.sync (Event.send channel act) in
  Event.sync (Event.receive back)

let throw f x = 
  let act () = f x in
  Event.sync (Event.send channel act)

let workers () = ! worker_count
