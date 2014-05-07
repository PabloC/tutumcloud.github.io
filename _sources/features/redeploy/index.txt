:title: Hot redeployment

Hot redeployment
================

Tutum supports **hot redeployment** of applications while they are running.
This can be used when a new version of the image is pushed to the registry and you want your application
to regenerate its containers with it.

You can redeploy the latest version of the application's current image tag, or select a different tag of the same image.

When a hot redeployment is requested, Tutum will replace the application containers with the new version and/or the new image tag.
The container's endpoints will remain the same. Please note that any data stored locally in the application containers will
be destroyed.


Using the web interface
-----------------------

From the application detail page, click on the **Redeploy** button on the top right corner of the page. A modal
will be displayed:

.. image:: /_static/images/redeploy_modal.png
    :class: img-responsive img-thumbnail text-center

By default, the current image tag deployed will be selected, but you can also select a different tag from the same image to be deployed.
Click on **Deploy** to start the redeployment process.


Using the API
-------------

You can redeploy a new version of an application through the API:

.. sourcecode:: http

    POST /api/v1/application/(uuid)/redeploy/ HTTP/1.1

    {
        "tag": "latest"
    }

See :ref:`api-redeploy-ref` for more information.


Using the CLI
-------------

You can redeploy a new version of an application through the CLI:

.. sourcecode:: none

    $ tutum apps redeploy -t latest myapp

See :ref:`cli-ref` for more information.
