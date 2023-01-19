# About
This was a wifi hacking challenge set up for midnight sun, which ran in August 22

# How

mac_hwsim is a linux testing driver for the wireless subsystem.

We create various radios, assign them to radio groups for isolation, and beam them into docker containers.

To build and run:
```
#./host-install.sh
docker-compose build
./setup.sh
ssh root@localhost -p 2222
```

# What

Starting from the t1_attacker machine (you can ssh to the running host with root:mutant_n1nj4_turtle on port 2222)

You should hack across the networks and pick up flags. Start by taking a look at hwsim0

# Questions?

Feel free to contact us on the supernetworks discord https://discord.gg/EUjTKJPPAX
