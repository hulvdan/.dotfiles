;extends

(raw_string_literal
  delimiter: (raw_string_delimiter) @delimiter (#eq? @delimiter "VertexShader")
  (raw_string_content) @injection.content (#set! injection.language "glsl")
  (raw_string_delimiter))

(raw_string_literal
  delimiter: (raw_string_delimiter) @delimiter (#eq? @delimiter "FragmentShader")
  (raw_string_content) @injection.content (#set! injection.language "glsl")
  (raw_string_delimiter))
