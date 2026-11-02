# dev-docker

A security focused docker container with VNC to test the OWASP Juice Shop.

# Build

After changing into the dev-docker folder run:

  `docker build .`

# Run

Once the build is finished run:

  `docker compose up -d`

# Configure

By default there is no password for root or your user, in order to add a password you'll need to use docker exec -it.  Once you have a password you need to add the user to the sudoers file.

* root password:
  `docker exec -it -u root pentest passwd root`
* pentester password:
  `docker exec -it -u root pentest passwd pentester`
* Add user to sudoers file from root, this assumes the user is still pentester:
  `adduser pentester sudo`

The easiest way to verify VNC is working is to enter the docker container (pentest) as root, switch user into the specified Dockerfile user (pentester), then run the start-vnc.sh command.

  Example: 
  * `docker exec -it -u root pentest bash`
  * `su pentester`


Once inside the container as the user run 'start-vnc.sh' which has already been copied to /usr/local/bin so it can be ran without bash.

  `start-vnc.sh`

<img width="913" height="238" alt="image" src="https://github.com/user-attachments/assets/711391bc-6891-4275-8a96-1a33cb5fe8ef" />

# Connect with Your VNC Viewer

From Windows the VNC server can be connected with your preferred VNC Viewer @ localhost:5901:

<img width="825" height="316" alt="image" src="https://github.com/user-attachments/assets/e0cc4acd-e602-4f6a-8a36-ae9976233e95" />

Enter the password you set when you configured the VNC server.
<img width="751" height="223" alt="image" src="https://github.com/user-attachments/assets/47d66158-a44b-45f7-a527-7730ac3c3967" />

# Test! 
Test to see if you can use sudo with your user in the VNC session, if you can't you may need to logout of the user and re-login.  One way to do this is to exit from the VNC connection, then kill the VNC server session.

`docker exec -it -u root pentest bash`
`su pentester`
`tightvncserver -kill :1`

Then run start-vnc.sh again and test.
`start-vnc.sh`

Open a terminal to see what your IP is:
`ip a`

Run netdiscover to see what the Juice Shop IP is, change your IP accordingly:
`sudo netdiscover -i eth0 -r 172.23.0.0/16`

Test to see if you can access Juice Shop:
`curl 172.23.0.2:3000`

Juice Shop will be on port 3000.
<img width="1912" height="1266" alt="image" src="https://github.com/user-attachments/assets/b9870cd2-e2d2-483c-9ae6-a9c7195df285" />


Have Fun!  
