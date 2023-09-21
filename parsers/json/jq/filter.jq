recurse(.nodes[])
 | select(.type == "output") | .name as $output | recurse(.nodes[])
 | select(.type == "workspace") | .name as $workspace | recurse(.nodes[])
 | select(.shell) | {
   output: $output,
   workspace: $workspace,
   id,
   pid,
   name,
   app: (.app_id // .window_properties.class),
 }
