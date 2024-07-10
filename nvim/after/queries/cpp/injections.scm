; IT DOES NOT WORK!!!

(raw_string_literal
    delimiter: (raw_string_delimiter) @delimiter (#eq? @delimiter "VertexShader")
    ; (raw_string_content) @vertex_shader_injected @sql
    (raw_string_content) @glsl
    (raw_string_delimiter))

(raw_string_literal
    delimiter: (raw_string_delimiter) @delimiter (#eq? @delimiter "FragmentShader")
    ; (raw_string_content) @fragment_shader_injected @sql
    (raw_string_content) @glsl
    (raw_string_delimiter))
