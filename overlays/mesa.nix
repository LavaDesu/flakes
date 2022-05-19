self: super: {
  mesa = super.mesa.override { galliumDrivers = [ "auto" "zink" ]; };
}
