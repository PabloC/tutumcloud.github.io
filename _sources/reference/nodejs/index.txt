:title: Node.js library

Node.js library
===============

Overview
--------

Tutum provides an `open source Node.js library <https://github.com/goloroden/tutum>`__ that wraps its HTTP REST API,
making it easier to perform operations from Node.js applications.

Installation
------------

::

    $ npm install tutum


Quick start
-----------

The first thing you need to do is to integrate tutum in your application.

.. sourcecode:: javascript

    var tutum = require('tutum');

Then you need to authenticate using your username and your API key. To obtain your ApiKey, see :ref:`api-auth-ref`.

.. sourcecode:: javascript

    tutum.authenticate({ username: 'foo', apiKey: 'bar' }, function (err, cloud) {
      // ...
    });

The ``cloud`` object that is returned then gives you access to all of
Tutum’s functionality.

Applications
~~~~~~~~~~~~

Getting a list of applications
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To get a list of applications, call the ``getApplications`` function.

.. sourcecode:: javascript

    cloud.getApplications(function (err, applications, metadata) {
      // ...
    });

Optionally, you can provide query criteria.

.. sourcecode:: javascript

    cloud.getApplications({ limit: 10 }, function (err, applications, metadata) {
      // ...
    });



Getting application details
^^^^^^^^^^^^^^^^^^^^^^^^^^^

To get details for an applications, call the ``getApplicationDetails``
function.

.. sourcecode:: javascript

    cloud.getApplicationDetails(applicationId, function (err, details) {
      // ...
    });



Creating a new application
^^^^^^^^^^^^^^^^^^^^^^^^^^

To create a new application, call the ``createApplication`` function.

.. sourcecode:: javascript

    cloud.createApplication({ image: 'tutum/hello-world' }, function (err, details) {
      // ...
    });



Updating an application
^^^^^^^^^^^^^^^^^^^^^^^

To update an application, call the ``updateApplication`` function.

.. sourcecode:: javascript

    cloud.updateApplication(applicationId, { target_num_containers: 2 }, function (err, details) {
      // ...
    });


Starting an application
^^^^^^^^^^^^^^^^^^^^^^^

To start an application, call the ``startApplication`` function.

.. sourcecode:: javascript

    cloud.startApplication(applicationId, function (err, details) {
      // ...
    });


Stopping an application
^^^^^^^^^^^^^^^^^^^^^^^

To stop an application, call the ``stopApplication`` function.

.. sourcecode:: javascript

    cloud.stopApplication(applicationId, function (err, details) {
      // ...
    });


Terminating an application
^^^^^^^^^^^^^^^^^^^^^^^^^^

To terminate an application, call the ``terminateApplication`` function.

.. sourcecode:: javascript

    cloud.terminateApplication(applicationId, function (err, details) {
      // ...
    });


Running the tests
-----------------

This module can be built using `Grunt`_. Besides running the tests,
Grunt also analyses the code using `JSHint`_. To run Grunt, go to the
folder where you have installed tutum-node and run ``grunt``. You need
to have `grunt-cli`_ installed.

::

    $ grunt

Please note that for the tests to work you need a Tutum account. Add a
file with the name ``credentials.json`` to the ``test`` directory and
deposit your credentials in the following format:

.. sourcecode:: javascript

    {
      "username": "foo",
      "apiKey": "bar"
    }

The file ``.gitignore`` contains a rule that excludes this file from
being committed.


License
-------

The MIT License (MIT) Copyright (c) 2014 Golo Roden.

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
“Software”), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


.. _Grunt: http://gruntjs.com/
.. _JSHint: http://jshint.com/
.. _grunt-cli: https://github.com/gruntjs/grunt-cli