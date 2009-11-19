(*pp camlp4o `ocamlfind query -i-format lwt.syntax` pa_lwt.cmo *)

open Lwt
open Lwt_io
open Printf

let _ =
  let r = with_file ~mode:input "input.txt" 
    (fun ic ->
      let readfn = read_into ic in
      let e = Lens.env ~sz:3 ~readfn in
      let s = Lens.char_stream e in
      Lwt_stream.iter (fun c -> eprintf "'%c' %d\n" c (Char.code c)) s
    ) in
  Lwt_main.run r
