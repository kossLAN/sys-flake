<h1 align="center">
  SysFlake
  <br>
  <img src="resources/nixos.svg" width="200px" height="200px"/>
  <br>
  My trash system flake that you SHOULD NOT use!
</h1>

## Features
  - **Module first approach**: Everything that can be abstracted into modules is! Why? well that's because it allows me to bundle my apps with own configs together! 
  - **Management for my dotfiles in one place where I can easily switch between them** 
  - Don't know what else to put here, things are pretty bog standard

## Why you should not copy me
  - This is highly personal and not well documented because of that
  - I make mistakes/and or I'm lazy with this repo because I am the only customer
  - It's valuable to learn nix for yourself to effectively use it for yourself
  - If you do end up copying me I apologize...

## Credits (Cool people I copied/talked nix with)
  [NotAShelf](https://github.com/NotAShelf), [Misterio77](https://github.com/Misterio77), [outfoxxed](https://git.outfoxxed.me/) and probably others...

## Nice to know's 
  - Build a system(alternatively use nh):
    
    ```nixos-rebuild --flake .#<system> switch|boot```

  - Remote Deploy image to a server using nixos-anywhere

    ```nix run github:nix-community/nixos-anywhere -- --flake <path to configuration>#<configuration name> root@<ip address>```

## Disclaimer
  **You will not be able to build this yourself, to do so you would have to go a strip out any secret, I'm working on moving that all into their respective system configurations to make it easier to do this, but be aware of that**
