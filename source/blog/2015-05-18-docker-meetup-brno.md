---
title: First Docker Meetup in Brno, Czech Republic
author: bex
date: 2015-05-18 16:52:32 UTC
tags: Docker, Event
comments: true
published: true
---

<a href="https://plus.google.com/photos/111655466984621162361/albums/6148791279751551265/6148791280235588626?pid=6148791280235588626&oid=111655466984621162361"><img src="https://lh4.googleusercontent.com/-OpWbVxW3kLo/VVTlF3h2LBI/AAAAAAAAKZQ/MSTtCoauaoY/w761-h507-no/NI2S2355.jpg" width="200" height="133"></a>Last Thursday night, we held the first-ever Docker meetup in Brno. Approximately  100 people gathered to hear speakers from four different organizations on container technology and its use. The space, video recordings (links coming soon) and catering were provided through support from [Red Hat's Open Source and Standards Team](http://community.redhat.com), [Impact Hub](http://www.hubbrno.cz/en/), [Good Data](http://www.gooddata.com/), and [Seznam.cz](http://seznam.cz).

READMORE

**"How to explain Docker to your grandparents"** ([slides](https://podvody.fedorapeople.org/how_to_explain_dkr_.pdf), [video](http://www.motivp.com/shop/video/How_to_explain_Docker_to_your_grandparents)) by [Pavel Odvody](mailto:podvody@redhat.cz) ([github](https://github.com/shaded-enmity)) from Red Hat started off the evening.  In his talk, he explained the reasoning behind containers starting from the perspective of real world objects and no assumed knowledge.  He helped us understand why we need containers and how they accomplish their tasks.  He even touched on the ideas of containers as data stores for data we need to isolate. The presentation got the crowd ready and built a good knowledge base.  Questions started immediately including the important "What is the difference between a container and a VM?" question.

READMORE

In the cutely themed **"Marriage with Docker"** ([slides](http://www.slideshare.net/dusankatona/marriage-with-docker), [video](http://www.motivp.com/shop/video/Marriage_with_docker_hell_or_heaven)) presentation, [Dušan Katona](https://cz.linkedin.com/in/dusankatona) ([@dkatona](http://twitter.com/dkatona) of Good Data described the relationship his company has had with docker since January 2014 to today.  They are using docker in limited production.  His talk focussed on his company's work load requirement, the execution of arbitrary Ruby ETL (Extraction, Transformation, and Load) processes.  They dated around, considering OpenShift and Amazon and Google's nascent container services (at the time), but ultimately chose to start "going steady" with docker 0.7.6.  

After the "marriage" they had a fantastic honeymoon full of bliss and avoiding plain LXC code, having a REST API, and believing they could get to a single image with great resource limitation management.  Eventually, reality set in along with problems keeping their private registry set up, non-existant disk space limitations, network isolation issues and the inability to keep logs from getting large.  Finally, they reached some compromises in the marriage that have led to happiness, including using LXC to directly manage disk, putting in a program to manage logs and turning off the docker daemon's iptables routines and managing it externally.  Today they are the proud parents of about 1,000 containers a day on Docker 1.5, and that is just in limited rollout.

His big take away was that while he would do it again, knowing what he knows now, he thinks that it may be best to start with just dev and test environments until your operations team is ready to scale up for this work.

<a href="https://plus.google.com/photos/+EliskaSlobodova/albums/6149029480467230465/6149029732007516306?pid=6149029732007516306&oid=118153642793042046976"><img src="https://lh4.googleusercontent.com/-bYG0OsTyRKg/VVW99lmfmJI/AAAAAAAAIAw/2zSbIwkC-aQ/w761-h507-no/IMG_2968.jpg"></a>

During the break at the half-way point there was refreshment fueled socializating and conversation. I got pulled into a conversation about the suitability of docker for a new app being developed by a masters student at a local university. He has some interesting ideas, including possibly allowing his app to have a gui exposed via X-windows.

Tomáš Král ([@kadel](http://twitter.com/kadel) from Seznam.cz restarted the event with his talk about **"Running Docker Containers on a Mesos Cluster."** ([slides](http://www.slideshare.net/tomaskadel/running-docker-containers-on-mesos), [video](http://www.motivp.com/shop/video/Demo_deploy_containers_to_Mesos_cluster))  He began by describing Mesos and the Marathon frame work they use.  Then it was demo time.  He deployed his app and using JSON configuration files was able to specify the image and resource requirements.  Mesos provides health-checks, so the method was also defined.  First we saw the backend come online and then he started the frontend.  He demonstrated group management and a rolling upgrade.  

The first question after the presentation was about the difference between Mesos and Kubernetes.  He said they went with Mesos because it is a bit more mature and can run loads that are not containers.  This is important for their company as they are not 100% containerized.  This started a lively conversation about Mesos and how it can help with orchestration of containers.  One point in particular was around handling security issues at the container level, such as Heartbleed.  Their environment is setup with a Jenkins CI server that can rebuild and trigger redeployments easily.  When combined with their rolling upgrades, the process works well.

The final speaker of the night, [Pavel Šnajdr](mailto:snajpa@snajpa.net) from [vpsFree.cz](http://vpsfree.cz) provided us with an overview of the long history of containers in his talk, **"How Docker did not Invent Containers."** ([slides](https://vpsfree.cz/download/DM1501-How-docker-didnt-invent-containers.pdf), [video](http://www.motivp.com/shop/video/How_Docker_did_not_invent_the_containers))  He started by reviewing the differences between containers and virtual machines before taking on a journey all the way back to 1998 when container concepts first appeared in FreeBSD as jails.  

The world stayed basically unchanged until 2001 when SWSoft (now Parallels) introduced another container concept and linux-vserver appeared.  In 2004 Solaris Zones joined the scene and the OpenVZ project was open sourced by Parallels.  Features kept getting added and by 2007 IBM and HP had released container technologies.  In 2007 the vanilla kernel started to see the first major patches for containers with code from IBM and Google.  In 2008 LXC appeared and things kept growing. Finally in 2013 we see Docker appear on the scene.  Additional announcements have followed.  

In the end Pavel discussed the current state of containers in the vanilla kernel and the possibilities you can get by stacking OpenVZ inside of or on top of Docker.  His final statement reminded us that often a technology comes with a bias.  Docker tends to work better in some use cases but may not be as feature rich as alternatives like OpenVZ.  His last question to the audience was, "Do you want containers or do you want Docker?"

After more questions, the crowd broke up for discussions and retired to a local pub to finish watching the Czechs beat the Finns 5 to 3 in the Hockey World Championship.  Suffice it to say, the enthusiasm and celebration were not contained.

This event was made possible through the generous time of the speakers and support from [Red Hat's Open Source and Standards Team](http://community.redhat.com), [Impact Hub](http://www.hubbrno.cz/en/), [Good Data](http://www.gooddata.com/), and [Seznam.cz](http://seznam.cz).

Photos by [Jiri Folta](https://plus.google.com/111655466984621162361/about) and [Eliska Slobodova](https://plus.google.com/+EliskaSlobodova/about).