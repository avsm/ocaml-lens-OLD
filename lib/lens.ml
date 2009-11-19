(*pp camlp4o `ocamlfind query -i-format lwt.syntax` pa_lwt.cmo *)

open Lwt
open Printf

type env = {
  e_sz: int;   (* size of buffers *)
  e_readfn: (string -> int -> int -> int Lwt.t);  (* fill function *)
  e_head: buf;
  mutable e_tail: buf;
}

and buf = {
  b_buf: string;                  (* actual data buffer *)
  mutable b_sz: int;              (* valid size of data in buffer *)
  mutable b_next: buf option;
}

let buf ~sz =
  { b_buf = String.create sz; b_sz = 0; b_next = None }

let env ?(sz=4096) ~readfn =
  let b = buf ~sz in
  { e_sz = sz; e_readfn = readfn; e_head = b; e_tail = b }

(* prod the buffer to fill up some more and return how much it grew by *)
let read env =
  let tl = env.e_tail in
  let total_len = String.length tl.b_buf in
  if total_len > tl.b_sz then (
    (* fill in some data in this partially filled buffer *)
    lwt r = env.e_readfn tl.b_buf tl.b_sz (total_len - tl.b_sz) in
    tl.b_sz <- tl.b_sz + r;
    return r)
  else (
    (* construct a new buffer in the chain and fill it *)
    let buf = buf env.e_sz in
    tl.b_next <- Some buf;
    env.e_tail <- buf;
    lwt r = env.e_readfn buf.b_buf 0 env.e_sz in
    buf.b_sz <- r;
    return r)

(* fill the buffer by at least sz bytes *)
let read_at_least ~sz env =
  let rec fn acc =
    lwt r = read env in
    if acc + r >= sz then
      return ()
    else
      fn (acc + r) in
  fn 0

(* create a character stream from the buffer *)
let char_stream env =
  let buf = ref env.e_head in
  let posr = ref 0 in
  Lwt_stream.from (fun () ->
    match !posr with
      pos when pos < !buf.b_sz ->
       (* return character from current buffer *)
       let c = (!buf).b_buf.[pos] in
       incr posr;
       return (Some c)
    | pos when pos < (String.length !buf.b_buf) -> begin
       (* trigger a read within the same buffer *)
       lwt r = read env in
       match r with
         0 ->
           return None
       | r -> 
           let c = !buf.b_buf.[pos] in
           incr posr;
           return (Some c)
    end
    | pos -> begin
       (* move onto the next buffer *)
       lwt r = read env in
       match r with
         0 -> 
           return None
       | r -> begin
           match !buf.b_next with
             None -> 
               return None
           | Some buf' ->
               posr := 1;
               buf := buf';
               return (Some buf'.b_buf.[0])
       end  
    end
  )
