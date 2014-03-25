:title: Billing FAQ

Billing FAQ
===========

How am I billed?
----------------

Billing, payments, and associated information is encrypted and securely handled by Stripe. There is a 30-day billing cycle.
Containers are charged for 10 minutes of usage when they are launched (not 1 hour, like most cloud providers do).
After the initial 10 minutes, containers are charged per minute. We will bill your credit card on file after the billing cycles completes.
You can check your ongoing spending for the current billing cycle, as well as past bills, right from within Tutum's management console.


Do you charge for bandwidth transfer?
-------------------------------------

Incoming transfer into your container is always free. Every billing month, your container is given limited free bandwith transfer,
the amount of which varies with the size of the container (leftover is non-accumulative). Additional outgoing transfer is charged 12¢ per GB.


What is your SLA?
-----------------

During our public beta period we will not offer a Service Level Agreement (SLA). Sorry for the inconvenience.


How do I cancel my account?
---------------------------

During our public beta, please contact us directly at support@tutum.co to cancel your account.


Am I being charged while my container is stopped?
-------------------------------------------------

Yes, you will be charged at the same rate, per minute, as if your container were running. While your container is stopped
the local storage is not discarded. Additionally, you will benefit from extremely fast restart times, within 2 seconds.
Stop a container if you want to maintain its state, but disable access to it for any period of time.
