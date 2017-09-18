
to deploy the stack in swarm mode

create the .yml or .yaml file for stack deploy(docker-stack.yml)

To deploy : 
	docker stack deploy -c <docker-stack.yml> <sample-stack-name>

	example :	docker stack deploy -c docker-stack.yml sample
			
			OR
			
			docker stack deploy --compose-file sample

To List the stack :

	docker stack ls

To list services in the stack : 

	docker stack services <sample>





		
	



