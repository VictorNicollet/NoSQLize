(* NoSQLize - a public domain NoSQL storage and computation engine. *)

open Lwt

let dispatch req =

  let assoc_to_json list = 
    (* We are actually hacking around the HTTP library's inability to handle
       non-form-encoded POST data by parsing the form data as JSON fields. If
       a field is not valid JSON, it is treated as a string literal. *)
    `Object 
      (List.map 
	 (fun (key,value) -> key, try Json.json_of_string value with _ -> `String value)
	 list)
  in

  let result = 
    let uri = req # uri in
    let args = req # params_GET in
    let more = match req # meth with `GET -> `GET | `POST -> 
      let params = req # params_POST in 
      (* We are actually hacking around the HTTP library's inability to handle
	 DELETE & PUT requests by performing a POST and embedding the actual
	 method in the POST body. *)
      let meth = try Some (List.assoc "method" params) with Not_found -> None in 
      match meth with 
	| Some "DELETE" -> `DELETE 
	| Some "PUT"    -> `PUT (assoc_to_json (List.remove_assoc "method" params))
	| _             -> `POST (assoc_to_json params)
    in

    Api_parse.parse ~uri ~args ~more
  in
    
  (* Use the result to respond to the request *)
  result >>= fun (status,json) ->
  
  return 
    (fun outchan -> 
      Http_daemon.respond 
	~code:(`Code status)
	~body:(Json.string_of_json json)
	~headers:["Content-Type","application/json"]
	outchan)

let source_to_worker = Event.new_channel ()

let enqueue req outcome =
  let worker_to_source = Event.new_channel () in
  let back res = Event.sync (Event.send worker_to_source res) in
  let ()       = Event.sync (Event.send source_to_worker (req,back)) in
  let res      = Event.sync (Event.receive worker_to_source) in
  res outcome 
 
let rec loop () = 
  let worker =
    (* Try to dequeue a pending event if available, and return a worker
       thread to process it. *)
    match
      Event.poll (Event.receive source_to_worker)
    with 
      | Some (req,back) -> dispatch req >>= fun res -> return (back res)
      | None -> return ()
  in
  worker <&> ( Lwt_unix.yield () >>= loop ) 
    
let port = 7456
  
let spec =
  Http_types.({
    Http_daemon.default_spec with
      callback = enqueue ;
      mode     = `Thread ;
      timeout  = None ;
      port     ;
  })
    
let _ = 
  let _ = Thread.create Lwt_main.run (loop ()) in
  Http_daemon.main spec  
  
