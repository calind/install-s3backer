## Background
A Docker host (such as CoreOS and RedHat Atomic Host) usually is a minimal OS without the ability to compile custom client package. If you want to mount a fuse filesystem, it is quite hard to do it on the host. This image enables you to mount [s3backer](https://github.com/archiecobbs/s3backer) on such systems. It is based on [rootfs/install-glusterfs-on-fc21](https://github.com/rootfs/install-glusterfs-on-fc21).

## How it works

First pull the docker image 


    # docker pull quay.io/calind/install-s3backer:latest


Then run the image in [Super Privileged Container](http://developerblog.redhat.com/2014/11/06/introducing-a-super-privileged-container-concept/) mode

    #  docker run  --privileged -d  --net=host -e sysimage=/host -v /:/host -v /dev:/dev -v /proc:/proc -v /var:/var -v /run:/run quay.io/calind/install-s3backer
    
   
Get the the container's PID:

    # docker inspect --format {{.State.Pid}} <your_container_id>
    
My PID is *865*, I use this process's namespace to run the mount, note  the  */mnt* is in *host's* name space

    # nsenter --mount=/proc/865/ns/mnt s3backer --accessId=AWS_KEY --accessKey=AWS_SECRET --size=10G --blockSize=1M --vhost <your-bucket> /mnt
    
You can now check that s3backer is mounted at */mnt*.
