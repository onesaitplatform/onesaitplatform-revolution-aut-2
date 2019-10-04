# NGINX REMOTE RECONFIGURATION

This tool is designed to act as a comprehensive interface to the nginx-router deployed in the onesait-platform. It's main goal is to simplify the interaction with the nginx instance that bridges internal network services with the outer world.

## Installation

To install the nginx-reconf tool you can build your own doker image, first take a look to the `.env` file and customize it according to your needs, then try typing the following commands.

```bash
docker-compose build
docker-compose up -d
```

The docker image will expose 2 ports, 90TCP as the main nginx port, and 8000TCP as the configuration port. This behavior can be changed by editing the `nginx.conf` file available at the conf folder.

If you want to modify the behavior of the API, you can take a look inside the file `src/reconf/reconf/settings.py` and customize the following values:

```
CONFIG_PATH="/etc/nginx"
RECONF_COMMAND="nginx -s reload"
TEST_COMMAND="nginx -tc {filename}
```

## Usage

The interface provides the following functionality through a simple REST interface.

### Get current nginx configuration

Obtains the current configuration and returns it in plaintext.

```
Endpoint: http://127.0.0.1:8000/nginx
Verb: GET
Return Body: plaintext with the current nginx.conf file.
Return Code: 200 or 500.
```

###  Test nginx configuration 

Tests if the provided nginx configuration will run properly in the instance, the interface will place the configuration in the `/etc/nginx` folder and will run `nginx -tc {filename}`

If something goes wrong the interface will return the nginx error as-is in the body and the return code will be set to 500.

```
Endpoint: http://127.0.0.1:8000/nginx/test
Verb: POST
Form Data:
   Key: nginx
   Value: nginx config file.
Return Code: 200 or 500.
Return Body: The error returned by nginx.
```

###  Set nginx Configuration

Sets the provided configuration file as the main nginx configuration in the system, and takes a backup of the current configuration. This command will not test if the config file is correct, use with care. The server will perform a nginx reload executing the command  `nginx -s reload`. In the case that a wrong configuration is set, it may happen that nginx won't start, don't panic, the REST interface still allows you to undo the action.

```
Endpoint: http://127.0.0.1:8000/nginx/set
Verb: POST
Form Data:
   Key: nginx
   Value: nginx config file.
Return Code: 200 or 500.
Return Body: The Error returned by nginx.
```

###  Get All the Available Versions

Gets all the available versions stored as a backup in the nginx config folder and returns a json list with the version and the number.

```
Endpoint: http://127.0.0.1:8000/nginx/versions
Verb: GET
Return Code: 200 or 500.
Return Body: JSON list of versions.
[{"version": 1, "date": "2019-10-02"}, {"version": 2, "date": "2019-10-02"}]
```

### Get a Version

Gets a version listed as available in the versions list, and returns it as plaintext.

```
Endpoint: http://127.0.0.1:8000/nginx/version/{VERSION}
Verb: GET
Return Body: plaintext with the specified nginx.conf file version.
Return Code: 200, 405 or 500.
	405 Means that the requested version can not be found in the system.
```

### Return to the Last Used Version

Restores the last used nginx config version and reloads it with the command `nginx -s reload`.

```
Endpoint: http://127.0.0.1:8000/nginx/undo
Verb: PUT
Return Code: 200, 405 or 500.
	405 Means that there are no versions. Mainly, you are in the first configuration.
```

### Return to a Numbered Version 

Restores a version from the version list and reloads it with the command `nginx -s reload`.

```
Endpoint: http://127.0.0.1:8000/nginx/undo/{VERSION}
Verb: PUT
Return Code: 200, 405 or 500.
	405 Means that the requested version can not be found in the system.
```

### Reset nginx to the Initial Values

If nothing works you can always return to the initial `nginx.conf` file. You are welcome. 😊

```
Endpoint: http://127.0.0.1:8000/nginx/reset
Verb: PUT
Return Code: 200 or 500.
```

## Goodies

This tool is integrated in the onesite-platform with a simple GUI that will simplify the procedure. (WIP)
