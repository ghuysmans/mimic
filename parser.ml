open Lwt.Infix

module Rx = struct
  open Tyre

  let tcp =
    start *> str "Transmission Control Protocol, Src Port: " *> pos_int |>
    compile

  let sql =
    (* FIXME what about queries on multiple lines? *)
    start *> blanks *> str "Query: " *> regex Re.(rep any) |>
    compile
end


let read pcap =
  let p = "/usr/bin/tshark" in
  (* FIXME escape `pcap`! *)
  let argv = [| p; "-n"; "-r"; pcap; "-O"; "pgsql"; "pgsql.query" |] in
  let s = Lwt_process.pread_lines (p, argv) in
  let port = ref None in
  (* TODO generate an event stream: open, prepare, close! *)
  (* TODO detect RST and unexpected disconnections *)
  let f line queries =
    match Tyre.exec Rx.tcp line with
    | Error (`ConverterFailure e) ->
      Lwt.fail e (* this should not happen *)
    | Ok p ->
      port := Some p;
      Lwt.return queries
    | Error (`NoMatch _) ->
      match Tyre.exec Rx.sql line with
      | Ok sql ->
        let connection =
          match !port with
          | None -> assert false
          | Some p -> p
        in
        Lwt.return @@ {Query.connection; sql} :: queries
      | Error (`ConverterFailure _) ->
        assert false (* there's nothing to convert! *)
      | Error (`NoMatch _) ->
        Lwt.return queries
  in
  Lwt_stream.fold_s f s [] >|= List.rev
