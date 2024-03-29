(* NoSQLize - a public domain NoSQL storage and computation engine. *)

let uri_explode string = 
  List.filter (fun x -> x <> "")
    (BatString.nsplit string "/")

let uri_implode list = 
  String.concat "/"
    (List.filter (fun x -> x <> "") list)

let fresh = 

  let _uniq_b = ref 0 in
  let _uniq_c = Unix.getpid () in
  
  let seq = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz" in

  let base62 s o n i = 
    let rec aux i k = 
      if i <> 0 then begin
	s.[o + k] <- seq.[i mod 62] ;
	aux (i / 62) (k - 1)
      end
    in aux i (n-1) 
  in

  (* An unique identifier is written as "aaaaabbbccc" where
     - a is a base62 representation of the current time
     - b is the number of ids generated by this process (in base62)
     - c is the PID mod 238328
  *)

  fun () -> 
    let a = int_of_float (Unix.time() -. 1300000000.0)
    and b = incr _uniq_b ; !_uniq_b mod 238328
    and c = _uniq_c
    and s = String.make 11 '0' in
    base62 s 0 5 a ;
    base62 s 5 3 b ;
    base62 s 8 3 c ;
    s

