:title: Autodestroy

Autodestroy
===========

**Autodestroy** is a Tutum feature that when enabled on an application, will automatically terminate containers when they stop
(destroying all data within the container). This is useful for one-off actions which store results in a external system.
It can be set with the following values:

* **OFF**: if the container stops, regardless of the exit code, Tutum will not terminate it and will it in **Stopped** state.
* **ON_FAILURE**: if the container stops with an exit code different from 0, Tutum will automatically terminate it.
  Otherwise, it will leave it in **Stopped** state.
* **ALWAYS**: if the container stops, regardless of the exit code, Tutum will automatically terminate it.

If **Autorestart** and/or **Autoreplace** are activated, Tutum will try to perform those actions before **Autodestroy**.


Launching an application with Autodestroy activated through the API
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can enable autodestroy when launching an application through the API:

.. sourcecode:: javascript

    {
        "autodestroy": "ALWAYS",
        [...]
    }

If not provided, it will have a default value of **OFF**. See :ref:`api-launch-app` for more information.


Launching an application with Autodestroy activated through the CLI
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can enable autodestroy when launching an application using the CLI:

.. sourcecode:: none

    $ tutum apps run --autodestroy ALWAYS [...]

If not provided, it will have a default value of **OFF**. See :ref:`cli-ref` for more information.


Launching an application with Autodestroy activated through the UI
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

At the moment, activating the **Autodestroy** setting on the **Application configuration** step of the **Launch new application** wizard
sets the *autodestroy* setting to **ALWAYS**.

The default value is to be *deactivated* which will set it to **OFF**.


Activating Autodestroy to an already deployed application
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Using the API
-------------

You can set the autodestroy option after the application has been deployed through the API:

.. sourcecode:: http

    PATCH /api/v1/application/(uuid)/ HTTP/1.1

    {
        "autodestroy": "ALWAYS"
    }

See :ref:`api-update-app` for more information.


Using the CLI
-------------

You can set the autodestroy option after the application has been deployed using the CLI:

.. sourcecode:: none

    $ tutum apps set --autodestroy ALWAYS (name or uuid)

See :ref:`cli-ref` for more information.


Using the web interface
-----------------------

You can also activate or deactivate **Autodestroy** to an application after it has been deployed from within the application detail page.

.. image:: /_static/images/application_view_autodestroy.png
    :class: img-responsive img-thumbnail

You can click on the **Autodestroy** button to turn the feature **ON** or **OFF**. The behaviour of this settings is
the same as activating it on the **Application configuration** step of the **Launch new application** wizard.