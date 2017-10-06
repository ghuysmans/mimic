let name = "ocaml"

let to_id conn =
  "c" ^ string_of_int conn

let escape =
  String.escaped

let generate l =
  let open Lwt_io in
  printl "let () =" >>
  (* FIXME refactor this as the Parser evolves *)
  let conns = Query.get_connections l in
  let next_opened = ref conns in
  l |> Lwt_list.iter_s (fun {Query.connection; sql} ->
    let id = to_id connection in (* C identifier *)
    let q = escape sql in (* escaped SQL (since it's embedded into a string) *)
    let%lwt () =
      match !next_opened with
      | conn :: rest when conn = connection ->
        next_opened := rest;
        printf "  let %s = PGOCaml.connect () in\n" id
      | _ ->
        Lwt.return_unit
    in
    printf "  let _ = PGSQL(%s) \"%s\" in\n" id q) >>
  printl "  print_endline \"done.\";" >>
  (List.map to_id (List.rev conns) |>
    Lwt_list.iter_s (printf "  PGOCaml.close %s;\n")) >>
  printl "  ()"
