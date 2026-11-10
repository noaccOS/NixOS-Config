# atuin only binds the emacs/vi modes; replicates atuinsh/atuin#4019
$env.config.keybindings = $env.config.keybindings | each {|kb|
    match $kb.name {
        atuin => ($kb | update mode { append [helix_normal helix_insert helix_select] })
        atuin_up_arrow => ($kb | update mode { append [helix_normal helix_insert] })
        _ => $kb
    }
}
