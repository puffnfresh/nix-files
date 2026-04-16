{
  containers.sip = {
    config =
      { config, pkgs, ... }:
      {
        networking.firewall.allowedUDPPorts = [ 5060 ];
        networking.firewall.allowedUDPPortRanges = [
          {
            from = 11310;
            to = 11320;
          }
        ];
        systemd.services.asterisk.serviceConfig.Restart = "always";
        services.asterisk = {
          enable = true;
          confFiles = {
            "rtp.conf" = ''
              [general]
              rtpstart=11310
              rtpend=11320
            '';
            "pjsip.conf" = ''
              #include /var/lib/asterisk/tentative-auth.conf

              [transport-udp]
              type=transport
              protocol=udp
              bind=0.0.0.0
              external_media_address = 192.168.1.57
              external_signaling_address = 192.168.1.57
              local_net = 192.168.1.0/24

              [crazytel]
              type=endpoint
              transport=transport-udp
              context=from-pstn
              disallow=all
              allow=alaw,ulaw
              outbound_auth=crazytel
              aors=crazytel
              outbound_proxy=sip:melbourne.sip.crazytel.net.au
              from_domain=sip.crazytel.net.au

              [crazytel]
              type=aor
              qualify_frequency=60
              contact=sip:10298437@sip.crazytel.net.au:5060
              outbound_proxy=sip:melbourne.sip.crazytel.net.au

              [crazytel]
              type=registration
              transport=transport-udp
              outbound_auth=crazytel
              server_uri=sip:sip.crazytel.net.au:5060
              client_uri=sip:10298437@sip.crazytel.net.au
              retry_interval=60

              [crazytel]
              type=identify
              endpoint=crazytel
              match=sip.crazytel.net.au

              [brian]
              type=endpoint
              transport=transport-udp
              context=internal
              disallow=all
              allow=ulaw,alaw
              callerid="Brian" <201>
              auth=brian
              aors=brian
              direct_media=yes
              dtmf_mode=rfc4733
              force_rport=yes
              rewrite_contact=yes

              [brian]
              type=aor
              max_contacts=10
              remove_existing=no

              [loungeroom]
              type=endpoint
              transport=transport-udp
              context=internal
              disallow=all
              allow=ulaw,alaw
              callerid="Lounge Room" <202>
              aors=loungeroom
              auth=loungeroom
              direct_media=yes
              dtmf_mode=rfc4733
              force_rport=yes
              rewrite_contact=yes
              rtp_symmetric=yes

              [loungeroom]
              type=aor
              max_contacts=1
              remove_existing=yes

              [loungeroom]
              type=identify
              endpoint=loungeroom
              match=192.168.1.70

              [office]
              type=endpoint
              transport=transport-udp
              context=internal
              disallow=all
              allow=ulaw,alaw
              callerid="Brian's Office" <203>
              aors=office
              auth=office
              direct_media=yes
              dtmf_mode=rfc4733
              force_rport=yes
              rewrite_contact=yes
              rtp_symmetric=yes

              [office]
              type=aor
              max_contacts=1
              remove_existing=yes

              [office]
              type=identify
              endpoint=office
              match=192.168.1.158
            '';
            "extensions.conf" = ''
              [internal]
              exten => 201,1,Dial(PJSIP/brian,30)
               same => n,Hangup()

              exten => 202,1,Dial(PJSIP/loungeroom,30)
               same => n,Hangup()

              exten => 203,1,Dial(PJSIP/office,30)
               same => n,Hangup()

              [from-pstn]
              exten => _X.,1,NoOp(Inbound from PSTN)
               same => n,Dial(PJSIP/brian&PJSIP/office,20)
               same => n,Voicemail(brian,u)
               same => n,Hangup()
            '';
          };
        };
        system.stateVersion = "25.05";
      };
    forwardPorts = [
      { hostPort = 5060; protocol = "udp"; }

      { hostPort = 11310; protocol = "udp"; }
      { hostPort = 11311; protocol = "udp"; }
      { hostPort = 11312; protocol = "udp"; }
      { hostPort = 11313; protocol = "udp"; }
      { hostPort = 11314; protocol = "udp"; }
      { hostPort = 11315; protocol = "udp"; }
      { hostPort = 11316; protocol = "udp"; }
      { hostPort = 11317; protocol = "udp"; }
      { hostPort = 11318; protocol = "udp"; }
      { hostPort = 11319; protocol = "udp"; }
      { hostPort = 11320; protocol = "udp"; }
    ];
    autoStart = true;
  };

  networking.firewall.allowedUDPPorts = [ 5060 ];
}
