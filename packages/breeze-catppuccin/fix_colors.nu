#!/usr/bin/env nu

def apply_rules [file: path, rules: record] {
  $rules.replace
  | each {|rule| ast-grep -p $'<$$$A fill="($rule.fill)" $$$B/>' -r $'<$$$A fill="($rule.replace)" $$$B/>' --update-all $file }

  $rules.add
  | each {|rule| ast-grep -p $'<$$$A id="($rule.id)" $$$B/>' -r $'<$$$A id="($rule.id)" fill="($rule.fill)" $$$B/>' --update-all $file }
}

def render [ rules: record, input_file: path, src_directory: directory, output_directory: directory ] {
  let relative_path = $input_file | path relative-to $src_directory
  let output_file = $output_directory | path join $relative_path
  let temp_file = $output_directory | path join "temp-file.html"
  let path_data = $output_file | path parse --extension svg
  mkdir $path_data.parent

  let file_name = $relative_path | str replace -r '\.svg$' ''
  print $"customizing ($file_name)..."
#   print $input_file
# $rules.specific
#     | transpose name rule
#     | each {|rule| (glob ($src_directory | path join $"($rule.name).svg"))}
#     | print --raw
  
  let file_rules = $rules.specific
    | transpose name rule
    | where {|rule| $input_file in (glob ($src_directory | path join $"($rule.name).svg"))}
    | each {|rule| $rule.rule | merge deep --strategy=append { replace: [], add: [] } }

  cp $input_file $temp_file

  apply_rules $temp_file $rules.global
  $file_rules
  | each {|rule| apply_rules $temp_file $rule }

  mv $temp_file $output_file
}

def main [ rule_file: string, src_directory: directory, dest_directory: directory ] {
  let rules: record = cat $rule_file
    | from json
    | merge deep --strategy=append { global: { replace: [], add: [] }, specific: {} }

  fd -t f --extension svg --absolute-path --full-path $src_directory
  | lines
  | each { |svg_file|
    render $rules $svg_file $src_directory $dest_directory

  return 0
  }
}

