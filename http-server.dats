#include "share/atspre_staload.hats"
staload "libats/libc/SATS/netinet/in.sats"
staload "libats/libc/SATS/sys/socket.sats"
staload "libats/libc/SATS/sys/socket_in.sats"

#define DEFAULT_PORT 8080
#define VERBOSE true

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

  (* Fetch the port from command line arguments. *)
  val port = (if argc >= 2 then g0string2int(argv[1]) else DEFAULT_PORT): int
  val () = if VERBOSE then println!("port = ", port) else ()

  (* Define sockaddr_in structure *)
  var servaddr: sockaddr_in_struct
  val listening_port = in_port_nbo(port) // sin_port
  val address = in_addr_hbo2nbo(INADDR_ANY)
  val sin_family = AF_INET
  val () = sockaddr_in_init(servaddr, sin_family, address, listening_port)
}
