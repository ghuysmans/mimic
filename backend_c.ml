let name = "c"

let to_id conn =
  "c" ^ string_of_int conn

let escape =
  (* FIXME? *)
  String.escaped

let generate l =
  let open Lwt_io in
  printl "#include <stdio.h>" >>
  printl "#include <postgresql/libpq-fe.h>" >>
  printl "" >>
  printl "int main() {" >>
  printl "\tPGresult *req;" >>
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
        printf "\tPGconn *%s = PQconnectdb(\"\");\n" id
      | _ ->
        Lwt.return_unit
    in
    printf "\treq = PQprepare(%s, \"\", \"%s\", 0, NULL);\n" id q >>
    printf "\tprintf(\"%%s\", PQerrorMessage(%s));\n" id) >>
  printl "\tprintf(\"done.\\n\");" >>
  (List.map to_id (List.rev conns) |>
    Lwt_list.iter_s (printf "\tPQfinish(%s);\n")) >>
  printl "\treturn 0;" >>
  printl "}"
