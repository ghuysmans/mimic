# mimic

This tool allows you to replay queries from a tcpdump capture
(it relies on _tshark_ to read it) by generating programs
(currently, C/libpq and OCaml/pgocaml) you can later modify.

## Dependencies

### mimic
```shell
sudo apt install tshark
opam install lwt cmdliner tyre
```

### Generated OCaml
```shell
opam install pgocaml
```

## Limitations

You'll have to configure tshark to decode packets on exotic ports as pgsql's.
To do so, append this to your `~/.wireshark/decode_as_entries` file:
```
decode_as_entry: tcp.port,3000,(none),PGSQL
```

Connections aren't opened at the same time as they're in the capture.
Backends should process event streams instead of query streams!

Parsing probably fails with multiple-line queries.
