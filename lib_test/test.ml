(*pp camlp4o `ocamlfind query -i-format lwt.syntax` pa_lwt.cmo *)

open Lwt
open Lwt_io
open Printf

let _ =
  let r = Lens_unix.with_file "input.txt" 
    (fun env ->
      let s = Lens.char_stream env in
      Lwt_stream.iter (fun c -> eprintf "'%c' %d\n" c (Char.code c)) s
    ) in
  Lwt_main.run r
