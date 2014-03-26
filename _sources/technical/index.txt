:title: Technical FAQ

Technical FAQ
=============

Do you have an API?
-------------------

Yes, we have a :doc:`RESTful API </reference/api/index>`. The API allows you to create and destroy containers and application,
as well as replicate all of the application control panel functionality.


Do containers/applications have a firewall?
-------------------------------------------

With containers, only ports that have been explicitly exposed are open. All other ports are closed.


What kind of Virtualization do you use?
---------------------------------------

We use LXC and Docker.


What kind of Infrastructure does Tutum run on?
----------------------------------------------

Tutum runs on top of Amazon Web Services.


Can I set my own hostname?
--------------------------

Yes, we support custom hostnames using CNAMES for web applications (coming soon!).


Do you offer redundancy?
------------------------

Yes, when deploying an application to multiple containers, Tutum automatically deploys to different hosts in different availability zones. 
