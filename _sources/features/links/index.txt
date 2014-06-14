:title: Application links

Application links
=================

Tutum's application linking capabilities have been modeled after Docker's own
`Container Links <http://docs.docker.io/en/latest/use/working_with_links_names/>`_.

Linking applications exposes a pre-defined set of environment variables with information (i.e. hostname, port, etc.)
from the *linked* application to the *linking* application.

Tutum links your application to all of the linked application's containers. To do this, Tutum prefixes the environment
variables with a name you can specify, which defaults to the applications and container's names.

For example, let's say that you are running an application (``my-web-app``) with 2 containers (``my-web-app-1`` and ``my-web-app-2``).
You now want to launch a proxy that will balance HTTP traffic to each of the containers in your ``my-web-app`` application.
To launch the proxy, you would first select the appropriate image, then link it to your "web" application. By default,
the link name will be the linked application name (``my-web-app``), but you can also change this before deployment.
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


Environment variable propagation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Apart from the linked application connection details shown above, Tutum will also pass the environment variables that were
set in the linked application. This is useful, for example, to automatically pass connection authentication details.

If we launch an application ``my-db`` using the ``tutum/mysql`` image, with the following environment variable:

.. table::
    :class: table table-bordered table-striped

    =========== ===============
    Name        Value
    =========== ===============
    MYSQL_PASS  SECRETPASSWORD
    =========== ===============


And then, we launch another application ``my-wordpress`` using the ``tutum/wordpress-stackable`` image linked to
``my-db`` using a link name of ``DB``, the following environment variables will be available in this application:

.. table::
    :class: table table-bordered table-striped

    =============================== =============================================================================
    Name                           Value
    =============================== =============================================================================
    MY_MYSQL_1_PORT                 tcp://my-mysql-1-user.beta.tutum.io:49330
    MY_MYSQL_1_PORT_3306_TCP        tcp://my-mysql-1-user.beta.tutum.io:49330
    MY_MYSQL_1_PORT_3306_TCP_ADDR   my-mysql-1-user.beta.tutum.io
    MY_MYSQL_1_PORT_3306_TCP_PORT   49330
    MY_MYSQL_1_PORT_3306_TCP_PROTO  tcp
    MY_MYSQL_1_ENV_MYSQL_PASS       SECRETPASSWORD
    MY_MYSQL_TUTUM_API_URL          https://app.tutum.co/api/v1/application/6fe5029e-c125-4088-9b9a-4e74da20ac58/
    =============================== =============================================================================


Using Tutum API roles
---------------------

The above example is a very simple one. If ``my-web-app`` scales down, the proxy could detect this and remove the terminated container
from its member list. However, if ``my-web-app`` scales up, these environment variables alone will not be of any help to
detect the change.

You can give an application an API role. This role is a set of privileges granted to the application containers on the
Tutum API. At the moment we only support a "full" role which allows any operation to be performed on the API if granted.
To get the list of available roles see :ref:`api-launch-app`

The API role is passed in to the application containers as an authorization token stored in an environment variable called ``TUTUM_AUTH``.
This variable should be use to set the ``Authorization`` HTTP header when calling Tutum's API:

.. sourcecode:: bash

    curl -H "Authorization: $TUTUM_AUTH" https://app.tutum.co/api/v1/application/

Using this feature and following the example above, we can ask for updated information of the application using the
environment variable ``MY_WEB_APP_TUTUM_API_URL``:

.. sourcecode:: bash

    curl -H "Authorization: $TUTUM_AUTH" $MY_WEB_APP_TUTUM_API_URL

    {
        "container_ports": [
            {
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
        [...]
    }


Using this information (for example, by reading the ``containers`` attribute of the JSON response), the proxy can detect any changes
on the linked application and add and remove members as the application scales up or down.
