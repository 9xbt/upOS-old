%include "core.asm"

section .data
  msg_help_1: db `-- Functions --\r\n\0`
  msg_help_2: db ` help - Shows all functions.\r\n about - Shows information about the project.\r\n clear - Clears the screen.\r\n echo - Echoes what you say.\r\n credits - Shows the credits.\r\n user - Sets your username for this session.\r\n\n\0`

  cmd_help: db `help\0`
  cmd_help_alias: db `?\0`

section .text
  func_help:
    write nl
    cwrite msg_help_1, $02
    write msg_help_2
    ret