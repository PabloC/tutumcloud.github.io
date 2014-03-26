:title: Linking applications

Linking applications
====================

Tutum's application linking capabilities have been modeled after Docker's own
`Container Links <http://docs.docker.io/en/latest/use/working_with_links_names/>`_.

Linking applications exposes a pre-defined set of environment variables with information (i.e. hostname, port, etc.)
from the *linked* application to the *linking* application.

Tutum links your application to all of the linked application's containers. To do this, Tutum prefixes the environment
variables with the applications and container's names.

For example, let's say that you are running an application (``my-web-app``) with 2 containers (``my-web-app-1`` and ``my-web-app-2``).
You now want to launch a proxy that will balance HTTP traffic to each of the containers in your ``my-web-app`` application.
To launch the proxy, you would first select the appropriate image, then link it to your "web" application.
These are the environment variables that would be passed to your proxy:


.. table::
    :class: table table-bordered table-striped

    ============================== =============================================================================
    Name                           Value
    ============================== =============================================================================
    MY_WEB_APP_1_PORT              tcp://my-web-app-1-user.beta.tutum.io:49330
    MY_WEB_APP_1_PORT_80_TCP       tcp://my-web-app-1-user.beta.tutum.io:49330
    MY_WEB_APP_1_PORT_80_TCP_ADDR  my-web-app-1-user.beta.tutum.io
    MY_WEB_APP_1_PORT_80_TCP_PORT  49330
    MY_WEB_APP_1_PORT_80_TCP_PROTO tcp
    MY_WEB_APP_2_PORT              tcp://my-web-app-2-user.delta.tutum.io:49331
    MY_WEB_APP_2_PORT_80_TCP       tcp://my-web-app-2-user.delta.tutum.io:49331
    MY_WEB_APP_2_PORT_80_TCP_ADDR  my-web-app-2-user.delta.tutum.io
    MY_WEB_APP_2_PORT_80_TCP_PORT  49331
    MY_WEB_APP_2_PORT_80_TCP_PROTO tcp
    MY_WEB_APP_TUTUM_API_URL       https://app.tutum.co/api/v1/application/6fe5029e-c125-4088-9b9a-4e74da20ac58/
    ============================== =============================================================================

Your proxy application can now use these environment variables to configure itself on startup and start balancing traffic
between the two containers of ``my-web-app``.

You will notice that the last environment variable, ``MY_WEB_APP_TUTUM_API_URL``, is not defined in the Docker specification.
This is a special Tutum variable passed on every link that contains the Tutum API resource URI of the linked application.
This can be used, in conjunction with API roles (see below), to check for updates in the linked application.


Using Tutum API roles
---------------------

The above example is a very simple one. If ``my-web-app`` scales down, the proxy could detect this and remove the terminated container
from its member list. However, if ``my-web-app`` scales up, these environment variables alone will not be of any help to
detect the change.

You can give an application an API role. This role is a set of privileges granted to the application containers on the
Tutum API. At the moment we only support a "full" role which allows any operation to be performed on the API if granted.
To get the list of available roles you can query the API: see :ref:`api-roles`

The API role is passed in to the application containers as an authorization token stored in an environment variable called ``TUTUM_AUTH``.
This variable should be use to set the ``Authorization`` HTTP header when calling Tutum's API:

.. sourcecode:: bash

    curl -H "Authorization: $TUTUM_AUTH" https://app.tutum.co/api/v1/application/

Using this feature and following the example above, we can ask for updated information of the application using the
environment variable ``MY_WEB_APP_TUTUM_API_URL``:

.. sourcecode:: bash

    curl -H "Authorization: $TUTUM_AUTH" $MY_WEB_APP_TUTUM_API_URL

    {
        "autodestroy": "OFF",
        "autoreplace": "OFF",
        "autorestart": "OFF",
        "container_envvars": [],
        "container_ports": [
            {
                "application": "/api/v1/application/6fe5029e-c125-4088-9b9a-4e74da20ac58/",
                "inner_port": 80,
                "outer_port": null,
                "protocol": "tcp"
            }
        ],
        "container_size": "XS",
        "containers": [
            "/api/v1/container/7d6696b7-fbaf-471d-8e6b-ce7052586c24/",
            "/api/v1/container/83499f74-85b1-4f69-9ab3-658a67535f70/"
        ],
        "current_num_containers": 2,
        "deployed_datetime": "Mon, 24 Mar 2014 23:58:15 +0000",
        "destroyed_datetime": null,
        "entrypoint": "",
        "image_tag": "/api/v1/image/tutum/hello-world/tag/latest/",
        "link_variables": {
            "MY_WEB_APP_1_PORT": "tcp://my-web-app-1-admin.beta.tutum.io:49330",
            "MY_WEB_APP_1_PORT_80_TCP": "tcp://my-web-app-1-admin.beta.tutum.io:49330",
            "MY_WEB_APP_1_PORT_80_TCP_ADDR": "my-web-app-1-admin.beta.tutum.io",
            "MY_WEB_APP_1_PORT_80_TCP_PORT": "49330",
            "MY_WEB_APP_1_PORT_80_TCP_PROTO": "tcp",
            "MY_WEB_APP_2_PORT": "tcp://my-web-app-2-admin.beta.tutum.io:49331",
            "MY_WEB_APP_2_PORT_80_TCP": "tcp://my-web-app-2-admin.beta.tutum.io:49331",
            "MY_WEB_APP_2_PORT_80_TCP_ADDR": "my-web-app-2-admin.beta.tutum.io",
            "MY_WEB_APP_2_PORT_80_TCP_PORT": "49331",
            "MY_WEB_APP_2_PORT_80_TCP_PROTO": "tcp",
            "MY_WEB_APP_TUTUM_API_URL": "https://app.tutum.co/api/v1/application/6fe5029e-c125-4088-9b9a-4e74da20ac58/"
        },
        "linked_from_application": [],
        "linked_to_application": [],
        "name": "my-web-app",
        "resource_uri": "/api/v1/application/6fe5029e-c125-4088-9b9a-4e74da20ac58/",
        "roles": [],
        "run_command": "/run.sh",
        "running_num_containers": 1,
        "started_datetime": "Mon, 24 Mar 2014 23:58:15 +0000",
        "state": "Partly running",
        "stopped_datetime": null,
        "stopped_num_containers": 1,
        "target_num_containers": 2,
        "unique_name": "my-web-app",
        "uuid": "6fe5029e-c125-4088-9b9a-4e74da20ac58"
    }


Using this information (reading the ``containers`` attribute of the JSON response), the proxy can detect any changes
on the linked application and add and remove members as the application scales up or down.
