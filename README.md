# Fold Docs Package

Fold docstrings in the current file

## Keybinding:

<kbd>ctrl</kbd>+<kbd>alt</kbd>+<kbd>d</kbd>: Toggles folding of docstrings

## Settings

| Setting                | Default | Description                                          |
| ---------------------- | ------- | ---------------------------------------------------- |
| Start of the docstring | `"""`   | RegExp identifying the start of a docstring          |
| End   of the docstring | `"""`   | RegExp identifying the end of a docstring            |
| Cozy                   | `true`  | No gaps between filtered lines (default is one line) |


## To Do:

- [x] Custom docstrings specifications
- [ ] Preserve pre-filter folding after toggle off

## Thanks

This package was inspired / helped by:
- [hide-lines](https://atom.io/packages/hide-lines)
- [highlight-selected](https://atom.io/packages/highlight-selected)
