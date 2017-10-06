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
