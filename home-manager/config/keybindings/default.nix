{...}: {
  targets.darwin.keybindings = {
    # Resolve MacOS invalid key sound per https://github.com/microsoft/vscode/issues/44070
    "@^\UF700" = "noop:";
    "@^\UF701" = "noop:";
    "@^\UF702" = "noop:";
    "@^\UF703" = "noop:";
    "@~^\UF700" = "noop:";
    "@~^\UF701" = "noop:";
    "@~^\UF702" = "noop:";
    "@~^\UF703" = "noop:";
  };
}
