{
  services.hydra = {
    enable = true;
    port = 3005;
    hydraURL = "https://hydra.home.brianmckenna.org";
    notificationSender = "hydra@localhost";
    # buildMachinesFiles = [];
    useSubstitutes = true;
    listenHost = "127.0.0.1";
  };
}
