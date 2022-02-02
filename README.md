# flakes
My NixOS config!

![Desktop](.github/screenshots/desktop.png?raw=true)
![Neovim](.github/screenshots/neovim.png?raw=true)

## Usage
I recommend more that you only simply look at the modules as inspiration for your own config. Some of them
may or may not work on your machine if copied directly (but theoretically they should).

But if you insist, just copy-paste one of the hosts in `hosts/`, one of the users in `users/`, and modify them
to your liking. Open up `flake.nix`, add your new host config at the bottom, and then build it!

## Hosts
| Name      | Description |
| -------   | ----------- |
| blossom   | Laptop and main PC |
| caramel   | Raspberry Pi 400, stateless |
| sugarcane | OVHCloud VPS, stateless |

## Users
| Name | Description |
| ---- | ----------- |
| rin  | Main user for usage |
| hana | Lightweight user intended for inspecting stateless hosts |

## License
Licensed under CC0; basically you can fork, modify, redistribute, or do whatever you want I don't really care.

Credit is appreciated but not necessary
