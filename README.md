Dotfiles
========

This is the default set of dotfiles for sjthespian.

Installing these depends on [Dotbot][dotbot]. There is a custom version of the dotbot install script that allows for different hosts to have different configurations. This is discussed in the [Dotbot tips and tricks][dotbot-tips] wiki.

The included bashrc prompt uses [bash-git-prompt][bash-git-prompt]. I have also split my bashrc into multiple files in bashrc.d to make it both easier to manage and to allow system-specific customizations. 

Something similar has been done with the ssh configuration, it is stored in individual files in ssh.d. These files are concatenated when dotbot is run, if any of them are newer than the existing ssh configuration, in order to build the ssh configuration file. The dotbot yaml files specifiy individual files in ssh.d rather than managing the entire directory to enable different host configurations to have differing ssh configurations. This also permits files to be placed in the ssh.d directory that are not included in the git repository.

Copyright (c) 2016 Daniel Rich. Released under the MIT License. See [LICENSE.md][license] for details.
* Dotbot Copyright (c) 2014-2016 Anish Athalye. Released under the MIT License. See [LICENSE.md][license] for details.
* bash-git-prompt Copyright (c) 2016 Martin Gondermann. Released under the BSD 2 Clause (NetBSD) license.
* Blackbox Copyright (c) 2014-2016 Stack Exchange, Inc.  Released under the MIT License.

[dotbot]: https://github.com/anishathalye/dotbot
[dotbot-tips]: https://github.com/anishathalye/dotbot/wiki/Tips-and-Tricks
[bash-git-prompt]: https://github.com/magicmonty/bash-git-prompt
[license]: LICENSE.md
