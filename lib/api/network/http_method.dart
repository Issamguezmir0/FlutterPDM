enum HttpMethod {
  get("GET"),
  post("POST"),
  put("PUT"),
  delete("DELETE");

  final String description;

  const HttpMethod(this.description);
}
