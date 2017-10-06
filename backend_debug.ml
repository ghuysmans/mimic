let name = "debug"

let generate l =
  let conns = Query.get_connections l in
  let conns_s = List.map string_of_int conns |> String.concat ", " in
  Lwt_io.printf "%d concurrent connections: %s\n" (List.length conns) conns_s >>
  Lwt_io.printl "Queries:" >>
  Lwt_list.iter_s (fun x -> Lwt_io.printl ("* " ^ Query.to_string x)) l
