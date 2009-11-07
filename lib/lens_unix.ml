(*pp camlp4o `ocamlfind query -i-format lwt.syntax` pa_lwt.cmo *)

open Lwt
open Lwt_io
open Printf

let _ =
  let r = with_file ~mode:input "test" 
    (fun ic ->
      let readfn buf off len =
        read_into ic buf off len in
      let e = Lens.env ~sz:100 ~readfn in
      let s = Lens.stream e in
      Lwt_stream.iter (fun c -> eprintf "%c %d-\n" c (Char.code c)) s
    ) in
  Lwt_main.run r
