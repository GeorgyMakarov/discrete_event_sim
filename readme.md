## Discrete event simulation in R

### Executive summary

Project shows how to use `simmer` package in R to simulate discrete events.
Discrete event simulation is helpful in management of services and/or
industrial manufacturing companies with serial production process. This
project consists of **3** parts.

First part of the project provides understanding of what is DES and how it
can help in taking data driven decisions. It is roughly based on:  

- [Stat Pharm video]  
- [Simmer docs]  

Second part of the project shows an abstract example of *DES* for a simple
queuing process of customers. This part's purpose is to give you an idea of
how you could organize your processes using data.

Third part of the project is a practical implementation of *DES* to a real
world sawmill process. The core idea of this part is to show how to deal
with obstacles that may arise during process improvement.The outcome of the
third part is a data product:

- [Sawmill DES]  

Connect with me:

[<img align="left" alt="GeorgyMakarov | LinkedIn" width="22px" src="https://cdn.jsdelivr.net/npm/simple-icons@v3/icons/linkedin.svg"/>][Linkedin]  

<br />

Languages and tools used in this project:

[<img align="left" alt="GeorgyMakarov | Rstudio" width="22px" src="https://rstudio.com/wp-content/uploads/2018/10/RStudio-Logo-gray.svg"/>][Rstudio]  
[<img align="left" alt="GeorgyMakarov | Github" width="22px" src="https://cdn.jsdelivr.net/npm/simple-icons@v3/icons/github.svg"/>][Github]  
[<img align="left" alt="GeorgyMakarov | Git" width="22px" src="https://cdn.jsdelivr.net/npm/simple-icons@v3/icons/git.svg"/>][Git]  

<br />


### Why even use discrete event simulation

*Discrete events simulation (hereinafter DES)* is a model, which reproduces
the operation of a system as a discrete sequence of events in time. Each
event occurs at a particular instant in time and marks a change of state in
the system. In *DES* a system is described by time delay between changes
of state in the system.

*DES* contains **5** elements:  

* entity -- an object that can interact with other objects;  
* attributes -- descriptors an entity: age, gender etc.;  
* resource -- a process that serves an entity in some way;  
* queues -- a list of entities waiting if a resource is busy;  
* event -- any change to the system;  


*Capacity of resource* is the number of entities a resource can serve
simultaneously. Imagine a doctor and a patient -- in this system the patient
is the entity and the doctor is the resource. A doctor can serve **1**
patient at a time -- this means that resource capacity is **one**.

*Resource utilization* is a result from division of *busy time* by 
*total time* for a given resource. 

*Queue logic* describes an order in which entities leave a queue. An order
is similar to bookkeeping methods of **FIFO**, **LIFO**, **HVF**:  

* FIFO -- first in queue leaves first;  
* LIFO -- first in queue leaves last;  
* HVF -- most expensive leaves first;  

Examples of *events*: create entity, entities interact, entity leaves the
system.

Why use *DES*:  

- [x] it is flexible to many applications;  
- [x] it is computationally efficient;  
- [x] it is helpful to avoid micromanagement in models;  


### Simple queue example

Simple queue process for this process uses an example of outpatient clinic.
The main entity is a patient. The patient follows a trajectory: nurse ->
doctor -> administrator. There are **3** types of resources: nurse, doctor,
administrator.

The nurse makes primary assessment and history taking. This process takes
*15* minutes in average. The nurse then sends a patient to any of available
doctors. Next step a doctor consults a patient -- this in average takes *20*
minutes. After that an administrator finalizes the process by scheduling
follow up appointment -- the mean time here is *5* minutes. A patient 
arrives every *5* minutes with a standard deviation of *0.5* minutes. The
simulation runs for *540* minutes.

Optimization parameters for this simulation are the utilization of resources
and the waiting time in a queue. The idea is that we do not want low
resources utilization due to economic reasons, but we do not want a patient
to wait in the queue too long for the same reasons.

Full code of the sim is here:

- [Simple queue]  


### Sawmill simulation

Sawmill simulation is loosely based on [Shewhart] individuals control chart.
The idea is that the process is in controlled state. That means that the
outcome of the process is pure random. There is no trend or seasonality.
The aim of the simulation is to predict the output of production.

The main entity is a log. A log follows a trajectory to one of *3* saws,
which cut the log into boards. The saws fail from time to time. When a saw
fails a repair man fixes it. The repair man has other jobs to do. When a
saw fails and a repair man is busy with other job he stops the other job and
starts a saw repair process. This way a saw repair has higher priority than
the other job.

There are *4* parameters a user can change in the simulation:  

* process time -- how long does it take a saw to cut a log;  
* time to fail -- how long does a saw work until it fails;  
* repair time  -- how long does it take to repair a saw;  
* sim duration -- how long does the simulation run;  

Parameters from first to third are in minutes. Fourth parameter is in weeks.
The output is the number of logs cut by *3* saws in total.

Following the idea of control charts it is easy to suggest that process
means for each of parameters may be at different levels. It is useful to
run the simulation using different mean combinations, which allows to
answer `what if?` types of questions, ex.:

- [x] what if saws break often?  
- [x] what if we do not have necessary parts to repair a saw?  
- [x] what if we do not have saw operators with good skills?  

Running the simulation helps a user to compare the output of production
with investments in preventing certain events to happen.

The code of the sim is here:

- [Sawmill sim code]




<br />
<br />

[Stat Pharm video]: https://www.youtube.com/watch?v=Qe1NvHJcmZs&t=4s  
[Simmer docs]: https://r-simmer.org
[Sawmill DES]: https://georgymakarov.shinyapps.io/discrete_event_sim/
[Linkedin]: https://www.linkedin.com/in/georgy-makarov-11436b42/  
[Rstudio]: https://rstudio.com
[Github]: https://github.com  
[Git]: https://git-scm.com  
[Simple queue]: https://github.com/GeorgyMakarov/discrete_event_sim/blob/main/simple_queue.R  
[Shewhart]: https://en.wikipedia.org/wiki/Shewhart_individuals_control_chart  
[Sawmill sim code]: https://github.com/GeorgyMakarov/discrete_event_sim/blob/main/sawmill_sim.R  


