:title: Web load balancing

Web load balancing
==================

With Tutum, hosting and scaling your web application containers is very simple. Tutum provides built in load balancing
based on `Hipache <https://github.com/dotcloud/hipache>`__ for your HTTP applications which configures itself automatically.

In order to activate load balancing, make sure that your containers expose the port ``80/tcp`` and that listen to HTTP requests
in that port. If that's the case, your application will be added to our managed load balancer automatically on launch.

Each one of your web application containers will still be accessible on their regular endpoints.


Specifying a custom domain name
-------------------------------

By default, Tutum will allocate a predefined domain name for your load balanced application in the form
``applicationname-username.web.tutum.io`` which resolves to our load balancer.

If you want to use your own domain name, you can specify it in your application detail view:

.. image:: /_static/images/application_custom_cname.png
    :class: img-responsive img-thumbnail

You must create a **CNAME** record in your domain DNS configuration in order to use your new custom domain. The new
domain name must resolve to the ``*.web.tutum.io`` domain name allocated by Tutum. For example:

``www.example.com    CNAME   mywebapp-username.web.tutum.io``

Your web application will still be accessible via the allocated ``*.web.tutum.io`` domain.


Scaling a web application
-------------------------

When you scale up your web application, the new containers will be automatically added to the load balancer. When
you scale down, the destroyed containers will be removed.

For more information on application scaling, please see :ref:`scaling-ref`.


Managing container failures
---------------------------

If any of the containers of your web application does not respond to a request in time (less than 30 seconds), it will
be automatically marked as *dead* by the load balancer and will not receive further traffic. The load balancer will
check every 30 seconds if the container has recovered.

If the container crashes, and **crash recovery** is enabled and it successfully restarts and/or replaces the container,
it will be added to the load balancer. If not enabled or the crash recovery system is unsuccessful, it will be left
in stopped state and removed from the load balancer. See :ref:`crash-recovery-ref` for more information.


Current limitations
-------------------

We are actively developing our load balancing system. For now, please be aware of the following limitations:

* Only applications which expose port `80/tcp` will be added to the load balancer.
* No HTTPS traffic is yet supported.
* No sticky sessions are yet supported.