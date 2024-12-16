#/bin/bash
router_name="ziti-private-green"
binder="ziti-private-blue"
dialer="${router_name}"

ziti edge login localhost:1280 -u admin -p admin -y
ziti edge delete edge-router "${router_name}"
ziti edge create edge-router "${router_name}" -o "/tmp/docker-demo/zitigreen/${router_name}.jwt" -t

ziti edge delete service-policy "http-web-test-blue.dial"
ziti edge delete service-policy "http-web-test-blue.binder"
ziti edge delete service "http-web-test-blue.svc"
ziti edge delete config "http-web-test-blue.intercept.v1"
ziti edge delete config "http-web-test-blue.host.v1"

ziti edge create config "http-web-test-blue.intercept.v1" intercept.v1 \
	'{"protocols":["tcp"],"addresses":["http-web-test-blue.ziti"], "portRanges":[{"low":8000, "high":8000}]}'

ziti edge create config "http-web-test-blue.host.v1" host.v1 \
	'{"protocol":"tcp", "address":"web-test-blue","port":8000 }'
	
ziti edge create service "http-web-test-blue.svc" \
	--configs "http-web-test-blue.intercept.v1","http-web-test-blue.host.v1"

ziti edge create service-policy "http-web-test-blue.dial" Dial \
	--service-roles "@http-web-test-blue.svc" \
	--identity-roles "@${dialer}" 
	
ziti edge create service-policy "http-web-test-blue.binder" Bind \
	--service-roles "@http-web-test-blue.svc" \
	--identity-roles "@${binder}" 

echo -n "ZITI_ENROLL_TOKEN=" > /tmp/docker-demo/zitigreen/.env
cat "/tmp/docker-demo/zitigreen/${router_name}.jwt" >> /tmp/docker-demo/zitigreen/.env
