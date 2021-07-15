self: super: {
  winetricks = super.winetricks.overrideAttrs (old: rec {
    name = "winetricks-20210528-073e2db";
    src = super.fetchFromGitHub {
      repo = "winetricks";
      owner = "Winetricks";
      rev = "073e2db522e7db56f83fab2338d831ac716264cb";
      sha256 = "1fic4wzc3qyw5bki4zx0h9g8yyhh8db806pwm8mz8qv4n7syk4dd";
    };
  });
}
