:title: HTTP API

.. _api-ref:

HTTP API
========

.. contents::
    :local:


Introduction
------------

Tutum currently offers an HTTP REST API which is used by both the Web UI and the CLI. In this document you will find
all the operations currently supported in the platform and examples on how to execute them as raw HTTP requests.


.. _api-auth-ref:

Authentication
--------------

In order to be able to make requests to the API, you should first obtain an ApiKey for your account.
For this, log into Tutum, click on the menu on the upper right corner of the screen, and select **Get Api Key**

The Tutum HTTP API is reachable through the following hostname::

    https://app.tutum.co/

All requests should be sent to this endpoint with the following ``Authorization`` header:

.. sourcecode:: bash

    curl -H "Authorization: ApiKey username:apikey" https://app.tutum.co/api/v1/application/


Applications
------------

List all applications
^^^^^^^^^^^^^^^^^^^^^

.. http:get:: /api/v1/application/

    This operation returns a list of all active and recently terminated (less than 5 minutes ago) applications.

    **Example request**:

    .. sourcecode:: http

        GET /api/v1/application/ HTTP/1.1
        Host: app.tutum.co
        Accept: application/json
        Authorization: ApiKey username:apikey

    **Example response**:

    .. sourcecode:: http

        HTTP/1.1 200 OK
        Cache-Control: must-revalidate, max-age=0
        Content-Type: application/json
        Vary: Accept, Authorization, Cookie

        {
            "meta": {
                "limit": 25,
                "next": null,
                "offset": 0,
                "previous": null,
                "total_count": 1
            },
            "objects": [
                {
                    "autodestroy": "OFF",
                    "autoreplace": "ALWAYS",
                    "autorestart": "ALWAYS",
                    "container_ports": [
                        {
                            "application": "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
                            "inner_port": 80,
                            "outer_port": null,
                            "protocol": "tcp"
                        }
                    ],
                    "container_size": "XS",
                    "current_num_containers": 2,
                    "deployed_datetime": "Sun, 6 Apr 2014 17:59:42 +0000",
                    "destroyed_datetime": null,
                    "entrypoint": "",
                    "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
                    "name": "my-web-app",
                    "public_dns": "my-web-app-admin.dev.tutum.io",
                    "resource_uri": "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
                    "run_command": "/run.sh",
                    "running_num_containers": 2,
                    "started_datetime": "Sun, 6 Apr 2014 17:59:42 +0000",
                    "state": "Running",
                    "stopped_datetime": null,
                    "stopped_num_containers": 0,
                    "target_num_containers": 2,
                    "unique_name": "my-web-app",
                    "uuid": "7eaf7fff-882c-4f3d-9a8f-a22317ac00ce",
                    "web_public_dns": "myapp.example.com"
                }
            ]
        }

    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :queryparam int offset: optional, start the list skipping the first ``offset`` records (default: 0)
    :queryparam int limit: optional, only return at most ``limit`` records (default: 25, max: 100)
    :queryparam string name: optional, filter applications by name
    :queryparam string uuid: optional, filter applications by UUID
    :queryparam string uuid__startswith: optional, filter applications by UUIDs that start with the given string
    :queryparam string state: optional, filter applications by state
    :statuscode 200: no error
    :statuscode 401: unauthorized (wrong credentials)


.. _api-application-ref:

Get application details
^^^^^^^^^^^^^^^^^^^^^^^

.. http:get:: /api/v1/application/(uuid)/

    Get all the details of an specific application

    **Example request**:

    .. sourcecode:: http

        GET /api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/ HTTP/1.1
        Host: app.tutum.co
        Accept: application/json
        Authorization: ApiKey username:apikey

    **Example response**:

    .. sourcecode:: http

        HTTP/1.1 200 OK
        Cache-Control: must-revalidate, max-age=0
        Content-Type: application/json
        Vary: Accept, Authorization, Cookie

        {
            "autodestroy": "OFF",
            "autoreplace": "ALWAYS",
            "autorestart": "ALWAYS",
            "container_envvars": [
                {
                    "application": "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
                    "key": "ENVIRONMENT",
                    "value": "dev"
                }
            ],
            "container_ports": [
                {
                    "application": "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
                    "inner_port": 80,
                    "outer_port": null,
                    "protocol": "tcp"
                }
            ],
            "container_size": "XS",
            "containers": [
                "/api/v1/container/285b1f78-acda-4360-a1c4-1282c5e2a287/",
                "/api/v1/container/fbb94d30-9b38-46d2-b7b2-03d8dc05e9ee/"
            ],
            "current_num_containers": 2,
            "deployed_datetime": "Sun, 6 Apr 2014 17:59:42 +0000",
            "destroyed_datetime": null,
            "entrypoint": "",
            "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
            "link_variables": {
                "MY_WEB_APP_1_PORT": "tcp://my-web-app-1-admin.alpha-dev.tutum.io:49219",
                "MY_WEB_APP_1_PORT_80_TCP": "tcp://my-web-app-1-admin.alpha-dev.tutum.io:49219",
                "MY_WEB_APP_1_PORT_80_TCP_ADDR": "my-web-app-1-admin.alpha-dev.tutum.io",
                "MY_WEB_APP_1_PORT_80_TCP_PORT": "49219",
                "MY_WEB_APP_1_PORT_80_TCP_PROTO": "tcp",
                "MY_WEB_APP_2_PORT": "tcp://my-web-app-2-admin.alpha-dev.tutum.io:49220",
                "MY_WEB_APP_2_PORT_80_TCP": "tcp://my-web-app-2-admin.alpha-dev.tutum.io:49220",
                "MY_WEB_APP_2_PORT_80_TCP_ADDR": "my-web-app-2-admin.alpha-dev.tutum.io",
                "MY_WEB_APP_2_PORT_80_TCP_PORT": "49220",
                "MY_WEB_APP_2_PORT_80_TCP_PROTO": "tcp",
                "MY_WEB_APP_TUTUM_API_URL": "https://app.tutum.co/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/"
            },
            "linked_from_application": [],
            "linked_to_application": [],
            "name": "my-web-app",
            "public_dns": "my-web-app-admin.dev.tutum.io",
            "resource_uri": "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
            "roles": [],
            "run_command": "/run.sh",
            "running_num_containers": 2,
            "started_datetime": "Sun, 6 Apr 2014 17:59:42 +0000",
            "state": "Running",
            "stopped_datetime": null,
            "stopped_num_containers": 0,
            "target_num_containers": 2,
            "unique_name": "my-web-app",
            "uuid": "7eaf7fff-882c-4f3d-9a8f-a22317ac00ce",
            "web_public_dns": "myapp.example.com"
        }

    :query uuid: the UUID of the application
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 200: no error
    :statuscode 401: unauthorized (wrong credentials)
    :statuscode 404: application not found


.. _api-launch-app:

Create and launch a new application
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. http:post:: /api/v1/application/

    Creates and deploys a new application

    **Example request**:

    .. sourcecode:: http

        POST /api/v1/application/ HTTP/1.1
        Host: app.tutum.co
        Accept: application/json
        Authorization: ApiKey username:apikey
        Content-Type: application/json

        {
            "image": "tutum/hello-world",
            "name": "my-awesome-app",
            "target_num_containers": 2,
            "container_size": "XS",
            "web_public_dns": "awesome-app.example.com"
        }

    **Example response**:

    .. sourcecode:: http

        HTTP/1.1 202 Accepted
        Cache-Control: must-revalidate, max-age=0
        Content-Type: application/json
        Vary: Accept, Authorization, Cookie

        {
            "autodestroy": "OFF",
            "autoreplace": "OFF",
            "autorestart": "OFF",
            "container_envvars": [],
            "container_ports": [
                {
                    "application": "/api/v1/application/1f234d1d-dae5-46c1-9ee5-770575fe3e6f/",
                    "inner_port": 80,
                    "outer_port": null,
                    "protocol": "tcp"
                }
            ],
            "container_size": "XS",
            "containers": [
                "/api/v1/container/4a7c672c-4f55-4417-9300-c932eabe7f7e/",
                "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/"
            ],
            "current_num_containers": 2,
            "deployed_datetime": null,
            "destroyed_datetime": null,
            "entrypoint": "",
            "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
            "link_variables": {
                "MY_AWESOME_APP_TUTUM_API_URL": "https://app.tutum.co/api/v1/application/1f234d1d-dae5-46c1-9ee5-770575fe3e6f/"
            },
            "linked_from_application": [],
            "linked_to_application": [],
            "name": "my-awesome-app",
            "public_dns": "my-awesome-app-admin.dev.tutum.io",
            "resource_uri": "/api/v1/application/1f234d1d-dae5-46c1-9ee5-770575fe3e6f/",
            "roles": [],
            "run_command": "/run.sh",
            "running_num_containers": 0,
            "started_datetime": null,
            "state": "Starting",
            "stopped_datetime": null,
            "stopped_num_containers": 0,
            "target_num_containers": 2,
            "unique_name": "my-awesome-app",
            "uuid": "1f234d1d-dae5-46c1-9ee5-770575fe3e6f",
            "web_public_dns": "awesome-app.example.com"
        }

    :jsonparam string image: required, the image used to deploy this application in docker format, i.e. ``tutum/hello-world``.
    :jsonparam string name: optional, a human-readable name for the application, i.e. ``my-hello-world-app`` (default: ``image_tag`` without namespace)
    :jsonparam string container_size: optional, the size of the application containers, i.e. ``M`` (default: ``XS``, possible values: ``XS``, ``S``, ``M``, ``L``, ``XL``)
    :jsonparam int target_num_containers: the number of containers to run for this application (default: 1)
    :jsonparam string run_command: optional, the command used to start the application containers, i.e. ``/run.sh`` (default: as defined in the image)
    :jsonparam string entrypoint: optional, the command prefix used to start the application containers, i.e. ``/usr/sbin/sshd`` (default: as defined in the image)
    :jsonparam array(object) container_ports: optional, an array of objects with port information to be exposed in the application containers, i.e. ``[{"protocol": "tcp", "inner_port": 80}]`` (default: as defined in the image)
    :jsonparam array(object) container_envvars: optional, an array of objects with environment variables to be set in the application containers on launch, i.e. ``[{"key": "DB_PASSWORD", "value": "mypass"}]`` (default: as defined in the image, plus any link- or role-generated variables)
    :jsonparam array(object) linked_to_application: optional, an array of application resource URIs to link this application to, i.e. ``["/api/v1/application/80ff1635-2d56-478d-a97f-9b59c720e513/"]`` (default: empty array)
    :jsonparam string autorestart: optional, whether the containers should be restarted if they stop, i.e. ``ALWAYS`` (default: ``OFF``, possible values: ``OFF``, ``ON_FAILURE``, ``ALWAYS``)
    :jsonparam string autoreplace: optional, whether the containers should be replaced with a new one if they stop, i.e. ``ALWAYS`` (default: ``OFF``, possible values: ``OFF``, ``ON_FAILURE``, ``ALWAYS``)
    :jsonparam string autodestroy: optional, whether the containers should be terminated if they stop, i.e. ``OFF`` (default: ``OFF``, possible values: ``OFF``, ``ON_FAILURE``, ``ALWAYS``)
    :jsonparam array(string) roles: optional, a list of Tutum API roles to grant the application, i.e. ``["global"]`` (default: empty array, possible values: ``global``)
    :jsonparam string web_public_dns: optional, a custom domain name to be used as CNAME for the application web endpoint, only available if the application listens in port 80, i.e. ``my-app.example.com`` (default: none)
    :reqheader Content-Type: required, only ``application/json`` is supported
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 202: operation accepted
    :statuscode 400: cannot perform the operation (probably there was a validation error on the given parameters)
    :statuscode 401: unauthorized (wrong credentials)

Update an application
^^^^^^^^^^^^^^^^^^^^^

.. http:patch:: /api/v1/application/(uuid)/

    Updates the application details and scales the application up or down accordingly

    **Example request**:

    .. sourcecode:: http

        PATCH /api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/ HTTP/1.1
        Host: app.tutum.co
        Accept: application/json
        Authorization: ApiKey username:apikey
        Content-Type: application/json

        {
            "target_num_containers": 3
        }

    **Example response**:

    .. sourcecode:: http

        HTTP/1.1 202 Accepted
        Cache-Control: must-revalidate, max-age=0
        Content-Type: application/json
        Vary: Accept, Authorization, Cookie

        {
          "target_num_containers" : 3,
          "deployed_datetime" : "Sun, 6 Apr 2014 17:59:42 +0000",
          "container_ports" : [
            {
              "outer_port" : null,
              "inner_port" : 80,
              "protocol" : "tcp",
              "application" : "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/"
            }
          ],
          "current_num_containers" : 3,
          "run_command" : "/run.sh",
          "autodestroy" : "OFF",
          "linked_to_application" : [],
          "container_size" : "XS",
          "started_datetime" : "Sun, 6 Apr 2014 17:59:42 +0000",
          "stopped_num_containers" : 0,
          "uuid" : "7eaf7fff-882c-4f3d-9a8f-a22317ac00ce",
          "name" : "my-web-app",
          "autorestart" : "ALWAYS",
          "destroyed_datetime" : null,
          "state" : "Scaling",
          "roles" : [],
          "containers" : [
            "/api/v1/container/285b1f78-acda-4360-a1c4-1282c5e2a287/",
            "/api/v1/container/fbb94d30-9b38-46d2-b7b2-03d8dc05e9ee/",
            "/api/v1/container/47a0411a-9f9d-4824-bbcd-f0761ac51c89/"
          ],
          "image_tag" : "/api/v1/image/tutum/hello-world/tag/latest/",
          "running_num_containers" : 2,
          "resource_uri" : "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
          "stopped_datetime" : null,
          "unique_name" : "my-web-app",
          "linked_from_application" : [],
          "web_public_dns" : "myapp.example.com",
          "entrypoint" : "",
          "public_dns" : "my-web-app-admin.dev.tutum.io",
          "container_envvars" : [
            {
              "key" : "ENVIRONMENT",
              "application" : "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
              "value" : "dev"
            }
          ],
          "autoreplace" : "ALWAYS",
          "link_variables" : {
            "MY_WEB_APP_2_PORT_80_TCP" : "tcp://my-web-app-2-admin.alpha-dev.tutum.io:49220",
            "MY_WEB_APP_TUTUM_API_URL" : "https://app.tutum.co/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
            "MY_WEB_APP_2_PORT" : "tcp://my-web-app-2-admin.alpha-dev.tutum.io:49220",
            "MY_WEB_APP_1_PORT_80_TCP_PROTO" : "tcp",
            "MY_WEB_APP_1_PORT" : "tcp://my-web-app-1-admin.alpha-dev.tutum.io:49219",
            "MY_WEB_APP_1_PORT_80_TCP_PORT" : "49219",
            "MY_WEB_APP_2_PORT_80_TCP_PORT" : "49220",
            "MY_WEB_APP_2_PORT_80_TCP_PROTO" : "tcp",
            "MY_WEB_APP_1_PORT_80_TCP" : "tcp://my-web-app-1-admin.alpha-dev.tutum.io:49219",
            "MY_WEB_APP_1_PORT_80_TCP_ADDR" : "my-web-app-1-admin.alpha-dev.tutum.io",
            "MY_WEB_APP_2_PORT_80_TCP_ADDR" : "my-web-app-2-admin.alpha-dev.tutum.io"
          }
        }

    :query uuid: the UUID of the application
    :jsonparam int target_num_containers: optional, the target number of containers to scale this application to
    :jsonparam string web_public_dns: optional, the custom domain name to use for this web application
    :reqheader Content-Type: required, only ``application/json`` is supported
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 202: operation accepted
    :statuscode 400: cannot perform the operation (probably the application is not in a suitable state)
    :statuscode 401: unauthorized (wrong credentials)

Start an application
^^^^^^^^^^^^^^^^^^^^

.. http:post:: /api/v1/application/(uuid)/start/

    Starts all the containers in a stopped application

    **Example request**:

    .. sourcecode:: http

        POST /api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/start/ HTTP/1.1
        Host: app.tutum.co
        Accept: application/json
        Authorization: ApiKey username:apikey

    **Example response**:

    .. sourcecode:: http

        HTTP/1.1 202 Accepted
        Cache-Control: must-revalidate, max-age=0
        Content-Type: application/json
        Vary: Accept, Authorization, Cookie

        {
            "autodestroy": "OFF",
            "autoreplace": "ALWAYS",
            "autorestart": "ALWAYS",
            "container_envvars": [
                {
                    "application": "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
                    "key": "ENVIRONMENT",
                    "value": "dev"
                }
            ],
            "container_ports": [
                {
                    "application": "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
                    "inner_port": 80,
                    "outer_port": null,
                    "protocol": "tcp"
                }
            ],
            "container_size": "XS",
            "containers": [
                "/api/v1/container/285b1f78-acda-4360-a1c4-1282c5e2a287/",
                "/api/v1/container/fbb94d30-9b38-46d2-b7b2-03d8dc05e9ee/",
                "/api/v1/container/47a0411a-9f9d-4824-bbcd-f0761ac51c89/"
            ],
            "current_num_containers": 3,
            "deployed_datetime": "Sun, 6 Apr 2014 17:59:42 +0000",
            "destroyed_datetime": null,
            "entrypoint": "",
            "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
            "link_variables": {
                "MY_WEB_APP_TUTUM_API_URL": "https://app.tutum.co/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/"
            },
            "linked_from_application": [],
            "linked_to_application": [],
            "name": "my-web-app",
            "public_dns": "my-web-app-admin.dev.tutum.io",
            "resource_uri": "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
            "roles": [],
            "run_command": "/run.sh",
            "running_num_containers": 0,
            "started_datetime": "Sun, 6 Apr 2014 17:59:42 +0000",
            "state": "Starting",
            "stopped_datetime": "Sun, 6 Apr 2014 18:21:22 +0000",
            "stopped_num_containers": 0,
            "target_num_containers": 3,
            "unique_name": "my-web-app",
            "uuid": "7eaf7fff-882c-4f3d-9a8f-a22317ac00ce",
            "web_public_dns": "myapp.example.com"
        }

    :query uuid: the UUID of the application
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 202: operation accepted
    :statuscode 400: cannot perform the operation (probably the application is not in a suitable state)
    :statuscode 401: unauthorized (wrong credentials)


Stop an application
^^^^^^^^^^^^^^^^^^^

.. http:post:: /api/v1/application/(uuid)/stop/

    Stops all the containers in a running application

    **Example request**:

    .. sourcecode:: http

        POST /api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/stop/ HTTP/1.1
        Host: app.tutum.co
        Accept: application/json
        Authorization: ApiKey username:apikey

    **Example response**:

    .. sourcecode:: http

        HTTP/1.1 202 Accepted
        Cache-Control: must-revalidate, max-age=0
        Content-Type: application/json
        Vary: Accept, Authorization, Cookie

        {
            "autodestroy": "OFF",
            "autoreplace": "ALWAYS",
            "autorestart": "ALWAYS",
            "container_envvars": [
                {
                    "application": "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
                    "key": "ENVIRONMENT",
                    "value": "dev"
                }
            ],
            "container_ports": [
                {
                    "application": "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
                    "inner_port": 80,
                    "outer_port": null,
                    "protocol": "tcp"
                }
            ],
            "container_size": "XS",
            "containers": [
                "/api/v1/container/285b1f78-acda-4360-a1c4-1282c5e2a287/",
                "/api/v1/container/fbb94d30-9b38-46d2-b7b2-03d8dc05e9ee/",
                "/api/v1/container/47a0411a-9f9d-4824-bbcd-f0761ac51c89/"
            ],
            "current_num_containers": 3,
            "deployed_datetime": "Sun, 6 Apr 2014 17:59:42 +0000",
            "destroyed_datetime": null,
            "entrypoint": "",
            "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
            "link_variables": {
                "MY_WEB_APP_TUTUM_API_URL": "https://app.tutum.co/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/"
            },
            "linked_from_application": [],
            "linked_to_application": [],
            "name": "my-web-app",
            "public_dns": "my-web-app-admin.dev.tutum.io",
            "resource_uri": "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
            "roles": [],
            "run_command": "/run.sh",
            "running_num_containers": 0,
            "started_datetime": "Sun, 6 Apr 2014 17:59:42 +0000",
            "state": "Stopping",
            "stopped_datetime": null,
            "stopped_num_containers": 0,
            "target_num_containers": 3,
            "unique_name": "my-web-app",
            "uuid": "7eaf7fff-882c-4f3d-9a8f-a22317ac00ce",
            "web_public_dns": "myapp.example.com"
        }

    :query uuid: the UUID of the application
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 202: operation accepted
    :statuscode 400: cannot perform the operation (probably the application is not in a suitable state)
    :statuscode 401: unauthorized (wrong credentials)


Terminate an application
^^^^^^^^^^^^^^^^^^^^^^^^

.. http:delete:: /api/v1/application/(uuid)/

    Destroy all the containers in an application. This is not reversible. All the data stored in all the application containers will be permanently deleted.

    **Example request**:

    .. sourcecode:: http

        DELETE /api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/ HTTP/1.1
        Host: app.tutum.co
        Accept: application/json
        Authorization: ApiKey username:apikey

    **Example response**:

    .. sourcecode:: http

        HTTP/1.1 202 Accepted
        Cache-Control: must-revalidate, max-age=0
        Content-Type: application/json
        Vary: Accept, Authorization, Cookie

        {
            "autodestroy": "OFF",
            "autoreplace": "ALWAYS",
            "autorestart": "ALWAYS",
            "container_envvars": [
                {
                    "application": "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
                    "key": "ENVIRONMENT",
                    "value": "dev"
                }
            ],
            "container_ports": [
                {
                    "application": "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
                    "inner_port": 80,
                    "outer_port": null,
                    "protocol": "tcp"
                }
            ],
            "container_size": "XS",
            "containers": [
                "/api/v1/container/285b1f78-acda-4360-a1c4-1282c5e2a287/",
                "/api/v1/container/fbb94d30-9b38-46d2-b7b2-03d8dc05e9ee/",
                "/api/v1/container/47a0411a-9f9d-4824-bbcd-f0761ac51c89/"
            ],
            "current_num_containers": 3,
            "deployed_datetime": "Sun, 6 Apr 2014 17:59:42 +0000",
            "destroyed_datetime": null,
            "entrypoint": "",
            "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
            "link_variables": {
                "MY_WEB_APP_TUTUM_API_URL": "https://app.tutum.co/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/"
            },
            "linked_from_application": [],
            "linked_to_application": [],
            "name": "my-web-app",
            "public_dns": "my-web-app-admin.dev.tutum.io",
            "resource_uri": "/api/v1/application/7eaf7fff-882c-4f3d-9a8f-a22317ac00ce/",
            "roles": [],
            "run_command": "/run.sh",
            "running_num_containers": 0,
            "started_datetime": "Sun, 6 Apr 2014 18:23:56 +0000",
            "state": "Terminating",
            "stopped_datetime": "Sun, 6 Apr 2014 18:21:22 +0000",
            "stopped_num_containers": 0,
            "target_num_containers": 3,
            "unique_name": "my-web-app",
            "uuid": "7eaf7fff-882c-4f3d-9a8f-a22317ac00ce",
            "web_public_dns": "myapp.example.com"
        }

    :query uuid: the UUID of the application
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 202: operation accepted
    :statuscode 400: cannot perform the operation (probably the application is not in a suitable state)
    :statuscode 401: unauthorized (wrong credentials)


Containers
----------

List all containers
^^^^^^^^^^^^^^^^^^^

.. http:get:: /api/v1/container/

    Returns a paginated list of all containers for all applications for the authenticated user

    **Example request**:

    .. sourcecode:: http

        GET /api/v1/container/ HTTP/1.1
        Host: app.tutum.co
        Accept: application/json
        Authorization: ApiKey username:apikey

    **Example response**:

    .. sourcecode:: http

        HTTP/1.1 200 OK
        Cache-Control: must-revalidate, max-age=0
        Content-Type: application/json
        Vary: Accept, Authorization, Cookie

        {
            "meta": {
                "limit": 25,
                "next": null,
                "offset": 0,
                "previous": null,
                "total_count": 2
            },
            "objects": [
                {
                    "application": "/api/v1/application/1f234d1d-dae5-46c1-9ee5-770575fe3e6f/",
                    "autodestroy": "OFF",
                    "autoreplace": "OFF",
                    "autorestart": "OFF",
                    "container_ports": [
                        {
                            "container": "/api/v1/container/4a7c672c-4f55-4417-9300-c932eabe7f7e/",
                            "inner_port": 80,
                            "outer_port": 49221,
                            "protocol": "tcp"
                        }
                    ],
                    "container_size": "XS",
                    "deployed_datetime": "Sun, 6 Apr 2014 18:11:17 +0000",
                    "destroyed_datetime": null,
                    "entrypoint": "",
                    "exit_code": null,
                    "exit_code_msg": null,
                    "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
                    "name": "my-awesome-app",
                    "public_dns": "my-awesome-app-1-admin.alpha-dev.tutum.io",
                    "resource_uri": "/api/v1/container/4a7c672c-4f55-4417-9300-c932eabe7f7e/",
                    "run_command": "/run.sh",
                    "started_datetime": "Sun, 6 Apr 2014 18:11:17 +0000",
                    "state": "Running",
                    "stopped_datetime": null,
                    "unique_name": "my-awesome-app-1",
                    "uuid": "4a7c672c-4f55-4417-9300-c932eabe7f7e"
                },
                {
                    "application": "/api/v1/application/1f234d1d-dae5-46c1-9ee5-770575fe3e6f/",
                    "autodestroy": "OFF",
                    "autoreplace": "OFF",
                    "autorestart": "OFF",
                    "container_ports": [
                        {
                            "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                            "inner_port": 80,
                            "outer_port": 49222,
                            "protocol": "tcp"
                        }
                    ],
                    "container_size": "XS",
                    "deployed_datetime": "Sun, 6 Apr 2014 18:11:22 +0000",
                    "destroyed_datetime": null,
                    "entrypoint": "",
                    "exit_code": null,
                    "exit_code_msg": null,
                    "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
                    "name": "my-awesome-app",
                    "public_dns": "my-awesome-app-2-admin.alpha-dev.tutum.io",
                    "resource_uri": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "run_command": "/run.sh",
                    "started_datetime": "Sun, 6 Apr 2014 18:11:22 +0000",
                    "state": "Running",
                    "stopped_datetime": null,
                    "unique_name": "my-awesome-app-2",
                    "uuid": "f5d64083-7698-4aec-b5dc-86a48be0f565"
                }
            ]
        }

    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :queryparam int offset: optional, start the list skipping the first ``offset`` records (default: 0)
    :queryparam int limit: optional, only return at most ``limit`` records (default: 25, max: 100)
    :queryparam string unique_name: optional, filter containers by name
    :queryparam string uuid: optional, filter containers by UUID
    :queryparam string uuid__startswith: optional, filter containers by UUIDs that start with the given string
    :queryparam string state: optional, filter containers by state
    :queryparam string application__name: optional, filter containers by application name
    :queryparam string application__uuid: optional, filter containers by application UUID
    :queryparam string application__state: optional, filter containers by application state
    :statuscode 200: no error
    :statuscode 401: unauthorized (wrong credentials)


Get container details
^^^^^^^^^^^^^^^^^^^^^

.. http:get:: /api/v1/container/(uuid)/

    Get all the details of an specific container

    **Example request**:

    .. sourcecode:: http

        GET /api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/ HTTP/1.1
        Host: app.tutum.co
        Accept: application/json
        Authorization: ApiKey username:apikey

    **Example response**:

    .. sourcecode:: http

        HTTP/1.1 200 OK
        Cache-Control: must-revalidate, max-age=0
        Content-Type: application/json
        Vary: Accept, Authorization, Cookie

        {
            "application": "/api/v1/application/1f234d1d-dae5-46c1-9ee5-770575fe3e6f/",
            "autodestroy": "OFF",
            "autoreplace": "OFF",
            "autorestart": "OFF",
            "container_envvars": [
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT",
                    "value": "tcp://my-awesome-app-1-admin.alpha-dev.tutum.io:49221"
                },
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT_80_TCP",
                    "value": "tcp://my-awesome-app-1-admin.alpha-dev.tutum.io:49221"
                },
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT_80_TCP_ADDR",
                    "value": "my-awesome-app-1-admin.alpha-dev.tutum.io"
                },
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT_80_TCP_PORT",
                    "value": "49221"
                },
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT_80_TCP_PROTO",
                    "value": "tcp"
                }
            ],
            "container_ports": [
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "inner_port": 80,
                    "outer_port": 49222,
                    "protocol": "tcp"
                }
            ],
            "container_size": "XS",
            "deployed_datetime": "Sun, 6 Apr 2014 18:11:22 +0000",
            "destroyed_datetime": null,
            "entrypoint": "",
            "exit_code": null,
            "exit_code_msg": null,
            "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
            "link_variables": {
                "MY_AWESOME_APP_2_PORT": "tcp://my-awesome-app-2-admin.alpha-dev.tutum.io:49222",
                "MY_AWESOME_APP_2_PORT_80_TCP": "tcp://my-awesome-app-2-admin.alpha-dev.tutum.io:49222",
                "MY_AWESOME_APP_2_PORT_80_TCP_ADDR": "my-awesome-app-2-admin.alpha-dev.tutum.io",
                "MY_AWESOME_APP_2_PORT_80_TCP_PORT": "49222",
                "MY_AWESOME_APP_2_PORT_80_TCP_PROTO": "tcp"
            },
            "linked_from_application": [],
            "linked_to_application": [],
            "name": "my-awesome-app",
            "public_dns": "my-awesome-app-2-admin.alpha-dev.tutum.io",
            "resource_uri": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
            "roles": [],
            "run_command": "/run.sh",
            "started_datetime": "Sun, 6 Apr 2014 18:11:22 +0000",
            "state": "Running",
            "stopped_datetime": null,
            "unique_name": "my-awesome-app-2",
            "uuid": "f5d64083-7698-4aec-b5dc-86a48be0f565"
        }

    :query uuid: the UUID of the container
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 200: no error
    :statuscode 404: container not found
    :statuscode 401: unauthorized (wrong credentials)


Start a container
^^^^^^^^^^^^^^^^^

.. http:post:: /api/v1/container/(uuid)/start/

    Starts a container that was previously stopped

    **Example request**:

    .. sourcecode:: http

        POST /api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/start/ HTTP/1.1
        Host: app.tutum.co
        Accept: application/json
        Authorization: ApiKey username:apikey

    **Example response**:

    .. sourcecode:: http

        HTTP/1.1 202 Accepted
        Cache-Control: must-revalidate, max-age=0
        Content-Type: application/json
        Vary: Accept, Authorization, Cookie

        {
            "application": "/api/v1/application/1f234d1d-dae5-46c1-9ee5-770575fe3e6f/",
            "autodestroy": "OFF",
            "autoreplace": "OFF",
            "autorestart": "OFF",
            "container_envvars": [
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT",
                    "value": "tcp://my-awesome-app-1-admin.alpha-dev.tutum.io:49221"
                },
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT_80_TCP",
                    "value": "tcp://my-awesome-app-1-admin.alpha-dev.tutum.io:49221"
                },
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT_80_TCP_ADDR",
                    "value": "my-awesome-app-1-admin.alpha-dev.tutum.io"
                },
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT_80_TCP_PORT",
                    "value": "49221"
                },
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT_80_TCP_PROTO",
                    "value": "tcp"
                }
            ],
            "container_ports": [
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "inner_port": 80,
                    "outer_port": 49222,
                    "protocol": "tcp"
                }
            ],
            "container_size": "XS",
            "deployed_datetime": "Sun, 6 Apr 2014 18:11:22 +0000",
            "destroyed_datetime": null,
            "entrypoint": "",
            "exit_code": 0,
            "exit_code_msg": "Exit code 0 (Success)",
            "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
            "link_variables": {
                "MY_AWESOME_APP_2_PORT": "tcp://my-awesome-app-2-admin.alpha-dev.tutum.io:49222",
                "MY_AWESOME_APP_2_PORT_80_TCP": "tcp://my-awesome-app-2-admin.alpha-dev.tutum.io:49222",
                "MY_AWESOME_APP_2_PORT_80_TCP_ADDR": "my-awesome-app-2-admin.alpha-dev.tutum.io",
                "MY_AWESOME_APP_2_PORT_80_TCP_PORT": "49222",
                "MY_AWESOME_APP_2_PORT_80_TCP_PROTO": "tcp"
            },
            "linked_from_application": [],
            "linked_to_application": [],
            "name": "my-awesome-app",
            "public_dns": "my-awesome-app-2-admin.alpha-dev.tutum.io",
            "resource_uri": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
            "roles": [],
            "run_command": "/run.sh",
            "started_datetime": "Sun, 6 Apr 2014 18:11:22 +0000",
            "state": "Starting",
            "stopped_datetime": "Sun, 6 Apr 2014 18:33:53 +0000",
            "unique_name": "my-awesome-app-2",
            "uuid": "f5d64083-7698-4aec-b5dc-86a48be0f565"
        }

    :query uuid: the UUID of the container
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 202: operation accepted
    :statuscode 400: cannot perform the operation (probably the container is not in a suitable state)
    :statuscode 401: unauthorized (wrong credentials)
    :statuscode 404: container not found


Stop a container
^^^^^^^^^^^^^^^^

.. http:post:: /api/v1/container/(uuid)/stop/

    Stops a running container

    **Example request**:

    .. sourcecode:: http

        POST /api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/stop/ HTTP/1.1
        Host: app.tutum.co
        Accept: application/json
        Authorization: ApiKey username:apikey

    **Example response**:

    .. sourcecode:: http

        HTTP/1.1 202 Accepted
        Cache-Control: must-revalidate, max-age=0
        Content-Type: application/json
        Vary: Accept, Authorization, Cookie

        {
            "application": "/api/v1/application/1f234d1d-dae5-46c1-9ee5-770575fe3e6f/",
            "autodestroy": "OFF",
            "autoreplace": "OFF",
            "autorestart": "OFF",
            "container_envvars": [
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT",
                    "value": "tcp://my-awesome-app-1-admin.alpha-dev.tutum.io:49221"
                },
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT_80_TCP",
                    "value": "tcp://my-awesome-app-1-admin.alpha-dev.tutum.io:49221"
                },
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT_80_TCP_ADDR",
                    "value": "my-awesome-app-1-admin.alpha-dev.tutum.io"
                },
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT_80_TCP_PORT",
                    "value": "49221"
                },
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT_80_TCP_PROTO",
                    "value": "tcp"
                }
            ],
            "container_ports": [
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "inner_port": 80,
                    "outer_port": 49222,
                    "protocol": "tcp"
                }
            ],
            "container_size": "XS",
            "deployed_datetime": "Sun, 6 Apr 2014 18:11:22 +0000",
            "destroyed_datetime": null,
            "entrypoint": "",
            "exit_code": null,
            "exit_code_msg": null,
            "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
            "link_variables": {
                "MY_AWESOME_APP_2_PORT": "tcp://my-awesome-app-2-admin.alpha-dev.tutum.io:49222",
                "MY_AWESOME_APP_2_PORT_80_TCP": "tcp://my-awesome-app-2-admin.alpha-dev.tutum.io:49222",
                "MY_AWESOME_APP_2_PORT_80_TCP_ADDR": "my-awesome-app-2-admin.alpha-dev.tutum.io",
                "MY_AWESOME_APP_2_PORT_80_TCP_PORT": "49222",
                "MY_AWESOME_APP_2_PORT_80_TCP_PROTO": "tcp"
            },
            "linked_from_application": [],
            "linked_to_application": [],
            "name": "my-awesome-app",
            "public_dns": "my-awesome-app-2-admin.alpha-dev.tutum.io",
            "resource_uri": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
            "roles": [],
            "run_command": "/run.sh",
            "started_datetime": "Sun, 6 Apr 2014 18:11:22 +0000",
            "state": "Stopping",
            "stopped_datetime": null,
            "unique_name": "my-awesome-app-2",
            "uuid": "f5d64083-7698-4aec-b5dc-86a48be0f565"
        }

    :query uuid: the UUID of the container
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 202: operation accepted
    :statuscode 400: cannot perform the operation (probably the container is not in a suitable state)
    :statuscode 401: unauthorized (wrong credentials)
    :statuscode 404: container not found


Get logs for a container
^^^^^^^^^^^^^^^^^^^^^^^^

.. http:get:: /api/v1/container/(uuid)/logs/

    Returns the logs of the specified container

    **Example request**:

    .. sourcecode:: http

        GET /api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/logs/ HTTP/1.1
        Host: app.tutum.co
        Accept: application/json
        Authorization: ApiKey username:apikey

    **Example response**:

    .. sourcecode:: http

        HTTP/1.1 200 OK
        Cache-Control: must-revalidate, max-age=0
        Content-Type: application/json
        Vary: Accept, Authorization, Cookie

        {
            "logs" : "2014-03-24 23:58:08,973 CRIT Supervisor running as root (no user in config file)\n2014-03-24 23:58:08,973 WARN Included extra file \"/etc/supervisor/conf.d/supervisord-apache2.conf\" during parsing"
        }

    :query uuid: the UUID of the container
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 200: no error
    :statuscode 401: unauthorized (wrong credentials)
    :statuscode 404: container not found


Terminate a container
^^^^^^^^^^^^^^^^^^^^^

.. http:delete:: /api/v1/container/(uuid)/

    Destroy the specified container and update the target number of containers of the related application. This is not reversible.
    All the data stored in the container will be permanently deleted. The parent application will scale down (will not try to replace it).

    **Example request**:

    .. sourcecode:: http

        DELETE /api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/ HTTP/1.1
        Host: app.tutum.co
        Accept: application/json
        Authorization: ApiKey username:apikey

    **Example response**:

    .. sourcecode:: http

        HTTP/1.1 202 Accepted
        Cache-Control: must-revalidate, max-age=0
        Content-Type: application/json
        Vary: Accept, Authorization, Cookie

        {
            "application": "/api/v1/application/1f234d1d-dae5-46c1-9ee5-770575fe3e6f/",
            "autodestroy": "OFF",
            "autoreplace": "OFF",
            "autorestart": "OFF",
            "container_envvars": [
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT",
                    "value": "tcp://my-awesome-app-1-admin.alpha-dev.tutum.io:49221"
                },
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT_80_TCP",
                    "value": "tcp://my-awesome-app-1-admin.alpha-dev.tutum.io:49221"
                },
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT_80_TCP_ADDR",
                    "value": "my-awesome-app-1-admin.alpha-dev.tutum.io"
                },
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT_80_TCP_PORT",
                    "value": "49221"
                },
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "key": "MY_AWESOME_APP_1_PORT_80_TCP_PROTO",
                    "value": "tcp"
                }
            ],
            "container_ports": [
                {
                    "container": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
                    "inner_port": 80,
                    "outer_port": 49222,
                    "protocol": "tcp"
                }
            ],
            "container_size": "XS",
            "deployed_datetime": "Sun, 6 Apr 2014 18:11:22 +0000",
            "destroyed_datetime": null,
            "entrypoint": "",
            "exit_code": 0,
            "exit_code_msg": "Exit code 0 (Success)",
            "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
            "link_variables": {
                "MY_AWESOME_APP_2_PORT": "tcp://my-awesome-app-2-admin.alpha-dev.tutum.io:49222",
                "MY_AWESOME_APP_2_PORT_80_TCP": "tcp://my-awesome-app-2-admin.alpha-dev.tutum.io:49222",
                "MY_AWESOME_APP_2_PORT_80_TCP_ADDR": "my-awesome-app-2-admin.alpha-dev.tutum.io",
                "MY_AWESOME_APP_2_PORT_80_TCP_PORT": "49222",
                "MY_AWESOME_APP_2_PORT_80_TCP_PROTO": "tcp"
            },
            "linked_from_application": [],
            "linked_to_application": [],
            "name": "my-awesome-app",
            "public_dns": "my-awesome-app-2-admin.alpha-dev.tutum.io",
            "resource_uri": "/api/v1/container/f5d64083-7698-4aec-b5dc-86a48be0f565/",
            "roles": [],
            "run_command": "/run.sh",
            "started_datetime": "Sun, 6 Apr 2014 18:35:03 +0000",
            "state": "Stopping",
            "stopped_datetime": "Sun, 6 Apr 2014 18:33:53 +0000",
            "unique_name": "my-awesome-app-2",
            "uuid": "f5d64083-7698-4aec-b5dc-86a48be0f565"
        }

    :query uuid: the UUID of the container
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 202: operation accepted
    :statuscode 400: cannot perform the operation (probably the container is not in a suitable state)
    :statuscode 401: unauthorized (wrong credentials)
    :statuscode 404: container not found


Images
------

List all images
^^^^^^^^^^^^^^^

.. http:get:: /api/v1/image/

    This operation returns a list of all jumpstarts, Linux and private images available to the user.

    **Example request**:

    .. sourcecode:: http

        GET /api/v1/image/?is_private_image=True HTTP/1.1
        Host: app.tutum.co
        Accept: application/json
        Authorization: ApiKey username:apikey

    **Example response**:

    .. sourcecode:: http

        HTTP/1.1 200 OK
        Cache-Control: must-revalidate, max-age=0
        Content-Type: application/json
        Vary: Accept, Authorization, Cookie

        {
            "meta": {
                "limit": 25,
                "next": null,
                "offset": 0,
                "previous": null,
                "total_count": 1
            },
            "objects": [
                {
                    "base_image": false,
                    "cluster_aware": false,
                    "description": "",
                    "docker_registry": "/api/v1/registry/r.tutum.co/",
                    "image_url": "",
                    "imagetag_set": [
                        "/api/v1/image/r.tutum.co/user/myimage/tag/latest/"
                    ],
                    "is_private_image": true,
                    "name": "r.tutum.co/user/myimage",
                    "public_url": "",
                    "resource_uri": "/api/v1/image/r.tutum.co/user/myimaget/",
                    "starred": false
                }
            ]
        }


    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :queryparam int offset: optional, start the list skipping the first ``offset`` records (default: 0)
    :queryparam int limit: optional, only return at most ``limit`` records (default: 25, max: 100)
    :queryparam string name: optional, filter applications by name
    :queryparam string unique_name: optional, filter applications by unique name (if ``name`` is not unique, Tutum will append a number to make it unique)
    :queryparam bool is_private_image: optional, display only private images
    :queryparam bool base_image: optional, display only Linux base images
    :queryparam bool starred: optional, display only jumpstart images
    :queryparam string docker_registry__host: optional, display only images stored in the specified host, i.e. ``r.tutum.co``
    :statuscode 200: no error
    :statuscode 401: unauthorized (wrong credentials)


Get image details
^^^^^^^^^^^^^^^^^

.. http:get:: /api/v1/image/(name)/

    Get all the details of an specific image

    **Example request**:

    .. sourcecode:: http

        GET /api/v1/image/tutum/lamp/ HTTP/1.1
        Host: app.tutum.co
        Accept: application/json
        Authorization: ApiKey username:apikey

    **Example response**:

    .. sourcecode:: http

        HTTP/1.1 200 OK
        Cache-Control: must-revalidate, max-age=0
        Content-Type: application/json
        Vary: Accept, Authorization, Cookie

        {
            "base_image": false,
            "cluster_aware": false,
            "description": "",
            "docker_registry": "/api/v1/registry/index.docker.io/",
            "image_url": "",
            "imagetag_set": [
                {
                    "full_name": "tutum/lamp:latest",
                    "image": {
                        "author": "Fernando Mayo",
                        "docker_id": "34ead373df921d5d28226e7a6795280f4f33bbfdf7ca0bc9c98a3e431a8f2e44",
                        "entrypoint": "",
                        "image_creation": "Thu, 6 Mar 2014 11:10:37 +0000",
                        "imageenvvar_set": [
                            {
                                "key": "HOME",
                                "value": "/"
                            },
                            {
                                "key": "PATH",
                                "value": "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
                            }
                        ],
                        "imageport_set": [
                            {
                                "port": 80,
                                "protocol": "tcp"
                            },
                            {
                                "port": 3306,
                                "protocol": "tcp"
                            }
                        ],
                        "run_command": "/run.sh"
                    },
                    "image_info": "/api/v1/image/tutum/lamp/",
                    "name": "latest",
                    "resource_uri": "/api/v1/image/tutum/lamp/tag/latest/"
                }
            ],
            "is_private_image": false,
            "name": "tutum/lamp",
            "public_url": "https://index.docker.io/u/tutum/lamp/",
            "resource_uri": "/api/v1/image/tutum/lamp/",
            "starred": false
        }

    :query name: the name of the image, i.e. ``tutum/lamp`` or ``r.tutum.co/user/myimage``
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 200: no error
    :statuscode 401: unauthorized (wrong credentials)
    :statuscode 404: application not found


Add a new private image
^^^^^^^^^^^^^^^^^^^^^^^

.. http:post:: /api/v1/image/

    Adds a private image to the user account to be used in application deployments. Note that private images pushed to
    Tutum's private registry will be added automatically.

    **Example request**:

    .. sourcecode:: http

        POST /api/v1/image/ HTTP/1.1
        Host: app.tutum.co
        Accept: application/json
        Authorization: ApiKey username:apikey
        Content-Type: application/json

        {
            "name": "quay.io/user/my-private-image",
            "username": "user+read",
            "password": "SHJW0SAOQ2BFBZVEVQH98SOL6V7UPQ0PH2VNKRVMMXR6T8Q43AHR88242FRPPTPG"
        }

    **Example response**:

    .. sourcecode:: http

        HTTP/1.1 202 Accepted
        Cache-Control: must-revalidate, max-age=0
        Content-Type: application/json
        Vary: Accept, Authorization, Cookie

        {
            "base_image": false,
            "cluster_aware": false,
            "description": "",
            "docker_registry": "/api/v1/registry/quay.io/",
            "image_url": "",
            "imagetag_set": [
                {
                    "full_name": "quay.io/user/my-private-image:latest",
                    "image": {
                        "author": "User <user@example.com>",
                        "docker_id": "9cd978db300e27386baa9dd791bf6dc818f13e52235b56e95703361ec3c94dc6",
                        "entrypoint": "",
                        "image_creation": "Mon, 3 Feb 2014 17:22:29 +0000",
                        "imageenvvar_set": [
                            {
                                "key": "HOME",
                                "value": "/"
                            },
                            {
                                "key": "PATH",
                                "value": "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
                            }
                        ],
                        "imageport_set": [],
                        "run_command": ""
                    },
                    "image_info": "/api/v1/image/quay.io/user/my-private-image/",
                    "name": "latest",
                    "resource_uri": "/api/v1/image/quay.io/user/my-private-image/tag/latest/"
                }
            ],
            "is_private_image": true,
            "name": "quay.io/tutum/test-repo3",
            "public_url": "https://quay.io/repository/user/my-private-image",
            "resource_uri": "/api/v1/image/quay.io/user/my-private-image/",
            "starred": false
        }

    :jsonparam string name: required, the image name to add in docker format, including the registry namespace, i.e. ``quay.io/user/my-private-image``.
    :jsonparam string username: required, the username to authenticate with the registry
    :jsonparam string password: required, the password to authenticate with the registry
    :jsonparam string description: optional, a description for the image
    :reqheader Content-Type: required, only ``application/json`` is supported
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 202: operation accepted
    :statuscode 400: cannot perform the operation (probably there was a validation error on the given parameters)
    :statuscode 401: unauthorized (wrong credentials)
    :statuscode 404: image not found


Update a private image
^^^^^^^^^^^^^^^^^^^^^^

.. http:patch:: /api/v1/image/(name)/

    Updates the credentials (username and password) and/or the description of a private image

    **Example request**:

    .. sourcecode:: http

        PATCH /api/v1/image/quay.io/user/my-private-image/ HTTP/1.1
        Host: app.tutum.co
        Accept: application/json
        Authorization: ApiKey username:apikey
        Content-Type: application/json

        {
            "description": "Awesome web application, containerized"
        }

    **Example response**:

    .. sourcecode:: http

        HTTP/1.1 202 Accepted
        Cache-Control: must-revalidate, max-age=0
        Content-Type: application/json
        Vary: Accept, Authorization, Cookie

        {
            "base_image": false,
            "cluster_aware": false,
            "description": "Awesome web application, containerized",
            "docker_registry": "/api/v1/registry/quay.io/",
            "image_url": "",
            "imagetag_set": [
                {
                    "full_name": "quay.io/user/my-private-image:latest",
                    "image": {
                        "author": "User <user@example.com>",
                        "docker_id": "9cd978db300e27386baa9dd791bf6dc818f13e52235b56e95703361ec3c94dc6",
                        "entrypoint": "",
                        "image_creation": "Mon, 3 Feb 2014 17:22:29 +0000",
                        "imageenvvar_set": [
                            {
                                "key": "HOME",
                                "value": "/"
                            },
                            {
                                "key": "PATH",
                                "value": "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
                            }
                        ],
                        "imageport_set": [],
                        "run_command": ""
                    },
                    "image_info": "/api/v1/image/quay.io/user/my-private-image/",
                    "name": "latest",
                    "resource_uri": "/api/v1/image/quay.io/user/my-private-image/tag/latest/"
                }
            ],
            "is_private_image": true,
            "name": "quay.io/tutum/test-repo3",
            "public_url": "https://quay.io/repository/user/my-private-image",
            "resource_uri": "/api/v1/image/quay.io/user/my-private-image/",
            "starred": false
        }

    :jsonparam string name: required, the image name to add in docker format, including the registry namespace, i.e. ``quay.io/user/my-private-image``.
    :jsonparam string username: optional, the username to authenticate with the registry
    :jsonparam string password: optional, the password to authenticate with the registry (required if ``username`` is given)
    :jsonparam string description: optional, a description for to the image
    :reqheader Content-Type: required, only ``application/json`` is supported
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 202: operation accepted
    :statuscode 400: cannot perform the operation (invalid parameters)
    :statuscode 401: unauthorized (wrong credentials)
    :statuscode 404: image not found


Delete a private image
^^^^^^^^^^^^^^^^^^^^^^

.. http:delete:: /api/v1/image/(name)/

    Delete a private image from the account. Please note that this does not delete the image in the source registry.

    **Example request**:

    .. sourcecode:: http

        DELETE /api/v1/image/quay.io/user/my-private-image/ HTTP/1.1
        Host: app.tutum.co
        Accept: application/json
        Authorization: ApiKey username:apikey

    **Example response**:

    .. sourcecode:: http

        HTTP/1.1 204 No Content
        Cache-Control: must-revalidate, max-age=0
        Content-Type: application/json
        Vary: Accept, Authorization, Cookie

    :jsonparam string name: required, the image name to add in docker format, including the registry namespace, i.e. ``quay.io/user/my-private-image``.
    :reqheader Authorization: required ApiKey authentication header in the format ``ApiKey username:apikey``
    :reqheader Accept: required, only ``application/json`` is supported
    :statuscode 204: operation accepted (no data returned in the body)
    :statuscode 401: unauthorized (wrong credentials)
    :statuscode 404: image not found
