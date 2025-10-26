sudo docker run --rm -it \  
	--network=host \  
	-e NVIDIA_DRIVER_CAPABILITIES=compute,utility,video,graphics \  
	--runtime nvidia \  
	--privileged \  
	-v /tmp/.X11-unix:/tmp/.X11-unix \  
	-v /etc/X11:/etc/X11 \  
	--device /dev/nvhost-vic \  
	-v /dev:/dev \  
	isaac-gr00t-n1.5:l4t-jp7.0
