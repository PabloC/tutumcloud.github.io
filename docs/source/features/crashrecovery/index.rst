:title: Crash Recovery

Crash Recovery
==============

**Crash recovery** is a Tutum feature that will autorestart and/or autoreplace your containers whenever they crash.

There are two settings related to crash recovery:

* **Autorestart**: Tutum will try to autorestart the crashed container up to three times in a 1 minute period.
* **Autoreplace**: Tutum will try to replace the crashed container with a new one up to three times in a 5 minute period.

Each of these settings have the following options:

* **OFF**: if the container stops, regardless of the exit code, Tutum will not try to autorestart/autoreplace it.
* **ON_FAILURE**: if the container stops with an exit code different from 0, Tutum will try to perform autorestart/autoreplace on it.
* **ALWAYS**: if the container stops, regardless of the exit code, Tutum will try to perform autorestart/autoreplace on it.

If both **Autorestart** and **Autoreplace** are activated, Tutum will try to perform **Autorestart** before **Autoreplace**.

If they fail to start the container after the number of tries during the periods described above, they will leave the
container in **Stopped** state.


Launching an application with Crash Recovery
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Using the API
-------------

You can specify the autorestart and autoreplace options when launching an application through the API:

.. sourcecode:: http

    POST /api/v1/application/ HTTP/1.1

    {
        "autorestart": "ON_FAILURE",
        "autoreplace": "ALWAYS",
        [...]
    }

If not provided, both are set to a default value of **OFF**. See :ref:`api-launch-app` for more information.


Using the CLI
-------------

You can specify the autorestart and autoreplace options when launching an application using the CLI:

.. sourcecode:: none

    $ tutum apps run --autorestart ON_FAILURE --autoreplace ALWAYS [...]

If not provided, both are set to a default value of **OFF**. See :ref:`cli-ref` for more information.


Using the web interface
-----------------------

At the moment, activating the **Crash recovery** setting on the **Application configuration** step of the **Launch new application** wizard
sets both *autorestart* and *autoreplace* settings to **ALWAYS**.

The default value is to be *deactivated* which will set both options to **OFF**.


Activating Crash Recovery to an already deployed application
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Using the API
-------------

You can set the autorestart and autoreplace options after the application has been deployed through the API:

.. sourcecode:: http

    PATCH /api/v1/application/(uuid)/ HTTP/1.1

    {
        "autorestart": "ON_FAILURE",
        "autoreplace": "ALWAYS"
    }

See :ref:`api-update-app` for more information.


Using the CLI
-------------

You can set the autorestart and autoreplace options after the application has been deployed using the CLI:

.. sourcecode:: none

    $ tutum apps set --autorestart ON_FAILURE --autoreplace ALWAYS (name or uuid)

See :ref:`cli-ref` for more information.


Using the web interface
-----------------------

You can also activate or deactivate **Crash Recovery** to an application after it has been deployed from within the application detail page.

.. image:: /_static/images/application_view_crash_recovery.png
    :class: img-responsive img-thumbnail

You can click on the **Crash Recovery** button to turn the feature **ON** or **OFF**. The behaviour of this settings is
the same as activating it on the **Application configuration** step of the **Launch new application** wizard.