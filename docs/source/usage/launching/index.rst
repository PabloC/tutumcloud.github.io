:title: Launching an application

Launching an application
========================

Tutum is a new type of cloud based on containers. With Tutum, you don't worry about servers or infrastructure at all,
yet you are not constrained by the platform itself. It is easy to run any service or application you want.
From open-source projects, to services (ie. databases, caches, proxies, etc.),
enterprise applications or even one-off commands (think cron jobs).

Tutum provides developers with "jumpstarts" to hit the ground running, but advance users can make use of Docker to
containerize custom applications, create complex environments and then quickly deploy and run them at scale to Tutum.

Let's get started already!


Select an Image to launch
^^^^^^^^^^^^^^^^^^^^^^^^^

When you first login, you'll see an empty dashboard (since you have not launched any application yet).

Click on the button that reads **Launch your first application**. A wizard to help you launch your application will show up.
It looks like this:

.. image:: /_static/images/image_selection_v1.png
    :class: img-responsive img-thumbnail

Let's use one of the **Jumpstarts** for your first application. Scroll down the list and select the **Wordpress + MySQL** jumpstart.
The image used for this jumpstart will launch a container running a **MySQL** database and a default **Wordpress** installation.
Click on **Select** to move on to the next step.


Configure the application
^^^^^^^^^^^^^^^^^^^^^^^^^

The next screen will look like this:

.. image:: /_static/images/application_configuration_v1.png
    :class: img-responsive img-thumbnail

You can modify any attribute of your application, but it will work just fine with the provided defaults.
In this step and the next (Environment variables) you can modify the parameters used to launch your application.


Launch!
^^^^^^^

Click on the **Launch** button (bottom right corner) at this screen to deploy your **Wordpress + MySQL application**.


Check your application
^^^^^^^^^^^^^^^^^^^^^^

After you click **launch** you will be taken to the **Application Dashboard**. You will see that your application is being deployed,
it should only take a handful of seconds to have your **Wordpress** application up and running.

Click on the application's name (*wordpress* if you did not change it) to load the **Application Detailed View**.

This is what it looks like:

.. image:: /_static/images/application_detail_wordpress_v1.png
    :class: img-responsive img-thumbnail

Clicking on your application's URL will open a new tab, where you'll see the Wordpress installation wizard.

.. image:: /_static/images/wordpress_installation_screen.png
    :class: img-responsive img-thumbnail

**Congratulations!** You have just launched your first application using Tutum.