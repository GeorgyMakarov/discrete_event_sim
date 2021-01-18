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

	- entity 	 -- an object that can interact with other objects;  
	- attributes -- features describing an entity: age, gender etc.;  
	- resource 	 -- 




<br />
<br />

[Stat Pharm video]: https://www.youtube.com/watch?v=Qe1NvHJcmZs&t=4s  
[Simmer docs]: https://r-simmer.org
[Sawmill DES]: https://rpubs.com/georgy_makarov/647960  
[Linkedin]: https://www.linkedin.com/in/georgy-makarov-11436b42/  
[Rstudio]: https://rstudio.com
[Github]: https://github.com  
[Git]: https://git-scm.com  

