```
vasm6502_oldstyle -Fbin -dotdir subroutines.s && \
  curl http://$IP/stop_clock && ruby trim_out.rb && \
  curl --request POST --url http://$IP/write --data-binary "@b.out" && \
  curl http://$IP/reset && \
  curl http://$IP/start_clock
```