 recurse(.nodes[], .floating_nodes[])
   | select(.type == "output") | .name as $output | recurse(.nodes[])
   | select(.type == "workspace") | .name as $workspace | recurse(.nodes[])
   | select(.shell) |
     "\($output) \($workspace) \(.id) \(.pid) \(.app_id // .window_properties.class) \(.name)"
