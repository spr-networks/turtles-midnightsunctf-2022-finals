# About
This was a wifi hacking challenge set up for midnight sun, which ran on-site during August 22 in Stockholm

# How

mac_hwsim is a linux testing driver for the wireless subsystem.

We create various radios, assign them to radio groups for isolation, and beam them into docker containers.

To build and run:
```
#./host-install.sh
docker-compose build
./setup.sh
ssh root@localhost -p 2222 (password is mutant_n1nj4_turtle)
```

# What

Starting from the t1_attacker machine, you should hack across the networks and pick up flags. 
Start by taking a look at sniffing some wiress traffic with hwsim0

# Questions?

Feel free to contact us at the supernetworks discord https://discord.gg/EUjTKJPPAX
