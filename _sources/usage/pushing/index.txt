:title: Pushing your app to Tutum

Pushing your app to Tutum
=========================

Tutum offers a free private Docker registry to its users. This short tutorial will guide you through the process to
upload/push your Docker images to Tutum's private registry. Application images pushed to Tutum's private registry will
automatically be shown in the **My Images** section of the **Launch new application** wizard.

First thing you'll need to push an image to Tutum's registry is to have Docker installed.
Please follow the `official installation instructions <https://www.docker.io/gettingstarted/>`_ depending on your system.

With Docker installed:

.. sourcecode:: none

    $ docker login r.tutum.co
    Username: user
    Password:
    Email: user@email.com
    Login Succeeded
    $ docker tag my_image r.tutum.co/user/my_image
    $ docker push r.tutum.co/user/my_image

Note: In the instructions above, please substitute ``user`` with your Tutum username, ``my_image`` with your image's name,
and ``user@email.com`` with the email you used to register at Tutum.

After you complete those steps, you'll see that your application image is available for selection in ``My Images``.