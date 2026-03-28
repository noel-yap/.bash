#!/bin/sh

eval "$(shellspec - -c) exit 1"

Describe 'prompt.shlib'

  Describe 'ps1-root()'
    Include prompt.shlib

    Context 'when not in a git repo'
      It 'does not include the git revision separator'
        run_ps1_root() {
          mock_first_with_rest git \
            'exit 128' \
            'exit 128'
          ps1-root
        }

        When call in_tempdir run_ps1_root
        The output should not include 'ᚴ'
      End

      It 'includes username:group@host[arch]:path format'
        run_ps1_root() {
          mock_first_with_rest git \
            'exit 128' \
            'exit 128'
          ps1-root
        }

        When call in_tempdir run_ps1_root
        The output should include '@\h['
        The output should include ']:\w'
      End
    End

    Context 'when on a named branch'
      It 'appends the branch name after ᚴ'
        run_ps1_root() {
          mock_first_with_rest git \
            'echo main' \
            'echo /path/to/parent/myrepo'
          ps1-root
        }

        When call in_tempdir run_ps1_root
        The output should include 'ᚴmain'
      End
    End

    Context 'when the branch name matches the repo root parent directory name'
      It 'does not include the git revision separator'
        run_ps1_root() {
          mock_first_with_rest git \
            'echo noel.yap' \
            'echo /Users/noel.yap/.bash' \
            'echo a1b2c3d4e5f6a7b8'
          ps1-root
        }

        When call in_tempdir run_ps1_root
        The output should not include 'ᚴ'
        The output should not include 'noel.yap'
      End
    End

    Context 'when on a detached HEAD with a reachable tag'
      It 'appends the tag name after ᚴ'
        run_ps1_root() {
          mock_first_with_rest git \
            'echo HEAD' \
            'echo v1.2.3'
          ps1-root
        }

        When call in_tempdir run_ps1_root
        The output should include 'ᚴv1.2.3'
      End
    End

    Context 'when on a detached HEAD with no reachable tag'
      It 'appends the abbreviated commit hash after ᚴ'
        run_ps1_root() {
          mock_first_with_rest git \
            'echo HEAD' \
            'exit 128' \
            'echo a1b2c3d4e5f6a7b8'
          ps1-root
        }

        When call in_tempdir run_ps1_root
        The output should include 'ᚴa1b2c3d4'
      End
    End
  End

  Describe 'prompt-command()'

    Context 'when TERM is xterm'
      TERM=xterm
      Include prompt.shlib

      It 'sets PS2 to two spaces'
        run_and_echo_ps2() {
          mock_first_with_rest git \
            'exit 128' \
            'exit 128'
          prompt-command
          printf '%s' "${PS2}"
        }

        When call in_tempdir run_and_echo_ps2
        The output should equal '  '
      End

      It 'sets PS1 with a terminal title escape sequence'
        run_and_echo_ps1() {
          mock_first_with_rest git \
            'exit 128' \
            'exit 128'
          prompt-command
          printf '%s' "${PS1}"
        }

        When call in_tempdir run_and_echo_ps1
        The output should include '\e]0;'
      End

      It 'sets PS1 ending with "> " before the title anchor'
        run_and_echo_ps1() {
          mock_first_with_rest git \
            'exit 128' \
            'exit 128'
          prompt-command
          printf '%s' "${PS1}"
        }

        When call in_tempdir run_and_echo_ps1
        The output should match pattern '*> *'
      End
    End

    Context 'when TERM is screen'
      TERM=screen
      Include prompt.shlib

      It 'sets PS2 to two spaces'
        run_and_echo_ps2() {
          mock_first_with_rest git \
            'exit 128' \
            'exit 128'
          prompt-command
          printf '%s' "${PS2}"
        }

        When call in_tempdir run_and_echo_ps2
        The output should equal '  '
      End

      It 'sets PS1 with a terminal title escape sequence'
        run_and_echo_ps1() {
          mock_first_with_rest git \
            'exit 128' \
            'exit 128'
          prompt-command
          printf '%s' "${PS1}"
        }

        When call in_tempdir run_and_echo_ps1
        The output should include '\e]0;'
      End
    End

    Context 'when TERM is dumb'
      TERM=dumb
      Include prompt.shlib

      It 'sets PS2 to two spaces'
        run_and_echo_ps2() {
          mock_first_with_rest git \
            'exit 128' \
            'exit 128'
          prompt-command
          printf '%s' "${PS2}"
        }

        When call in_tempdir run_and_echo_ps2
        The output should equal '  '
      End

      It 'sets PS1 ending with "> " and no title escape'
        run_and_echo_ps1() {
          mock_first_with_rest git \
            'exit 128' \
            'exit 128'
          prompt-command
          printf '%s' "${PS1}"
        }

        When call in_tempdir run_and_echo_ps1
        The output should match pattern '*> '
        The output should not include '\e]0;'
      End
    End

  End

End