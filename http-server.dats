(* #include "share/atspre_define.hats" *)
#include "share/atspre_staload.hats"
(* #include "libats/libc/DATS/sys/socket.dats" *)

#define DEFAULT_PORT 8080

// verb * resource * protocol
typedef raw_http_request = (string, string, string);

exception NotImplemented of (string)

datatype http_request =
  | http_request_delete of (string, string)
  | http_request_get    of (string, string)
  | http_request_post   of (string, string)
  | http_request_put    of (string, string)

fun refine_http_request(raw_request: raw_http_request): http_request =
  let val (verb, resource, protocol) = raw_request
  in
    case+ verb of
    | "DELETE" => http_request_delete(resource, protocol)
    | "GET"    => http_request_get(resource, protocol)
    | "POST"   => http_request_post(resource, protocol)
    | "PUT"    => http_request_put(resource, protocol)
    | nyi      => $raise NotImplemented(nyi)
  end

implement main0(argc, argv) = {
  val port = (if argc >= 2 then g0string2int(argv[1]) else DEFAULT_PORT): int;
}
