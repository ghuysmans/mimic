open Lwt.Infix
open Cmdliner

let mimic backend pcap = Lwt_main.run (
  Parser.read pcap >>=
  backend
)


let backend =
  let doc = "Output language" in
  let b = Arg.enum (List.map Backends.to_pair Backends.l) in
  Arg.(value & opt b Backend_debug.generate & info ["l"; "language"] ~doc)

(* TODO list_backends *)

let input =
  let doc = "Input pcap file" in
  Arg.(required & pos 0 (some file) None & info [] ~doc)


let cmd =
  let doc = "convert pcap of PostgreSQL to programs" in
  Term.(const mimic $ backend $ input),
  Term.info "mimic" ~doc

let () = Term.(exit @@ eval cmd)
