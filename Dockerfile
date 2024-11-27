FROM node:23-bookworm


RUN useradd -m -d /home/new_user new_user

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install sudo vim nano net-tools  iputils-ping python3-pip nmap netdiscover -y
# change the uid of new_user to ensure it has whatever it was assigned plus 1 (e.g. if UID was 1000, now it'll be 1001)
RUN id -u new_user | awk '{print $1+1}' | xargs -I{} usermod -u {} new_user
RUN usermod -aG sudo new_user 
RUN rm /usr/lib/python3.11/EXTERNALLY-MANAGED
RUN python3 -m pip install fastapi uvicorn 
# Copy the rest of the source files into the image.
#COPY ./App ./opt/App
RUN mkdir /opt/data
VOLUME ["/opt/data"]


# Expose the port that the application listens on.
#EXPOSE 43451


RUN cd /opt/data
ENTRYPOINT ["/bin/bash"]
