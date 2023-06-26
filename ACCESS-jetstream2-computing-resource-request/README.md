# Application submission info

---
> Submitted on 11-Jun-2023 (BIO230091); approved 12-Jun-2023
---

Submitted through ACCESS: https://access-ci.org/

Submitted an "Explore ACCESS", different types listed here: https://allocations.access-ci.org/prepare-requests-overview

After logged in, submission process started from this page: https://allocations.access-ci.org/opportunities

Then selecting to submit an Explore ACCESS request

## Required information I added to the form

**Title:** STAMPS 2023 at Marine Biologial Laboratory in Woods Hole, MA, USA

**Public overview:**  

> General overview  
> The STAMPS course (Strategies and Techniques for Analyzing Microbial Population Structures) has been a yearly event at the Marine Biological Laboratory (MBL) in Woods Hole, MA, USA for over a decade, helping nearly 1,000 learners establish a foundation in bioinformatics over the years. Since 2019 we have been fortunate enough to have our computational infrastructure provided through XSEDE and Jetstream(1 and 2), and we hope to continue that this year with ACCESS. The course takes place this year 19-July to 29-July and will involve a lot of command-line, R, amplicon analysis, metagenomics, statistical training, and other concepts and computational activities (last year's schedule can be seen here: https://github.com/mblstamps/stamps2022/wiki#schedule). 
>
> How we plan to use ACCESS resources  
> We will be running an about 10-day workshop (19-July to 29-July). I have experience in the past doing this through Indiana Jetstream2, managing through Exosphere, so that would be great if possible. We are requesting the ability to run 60 (accounting for faculty and participants) m3.large instances concurrently for the 14 days straight. This is longer than we plan on them being active, but would like to leave room for building the image and testing/setting things up ahead of time, and any unexpected situations. Using the jetstream estimator (https://wiki.jetstream-cloud.org/alloc/estimator/), with 60 m3.large instances for 14 days, this comes out to a request for 322,560 SUs/ACCESS Credits. We think this will work under the 400,000 max for "Explore ACCESS" allocations. Since we will be using these all at once over a short time, we do request the full amount to be released up front if possible. Please let me know if I should be estimating a different way or if any other information is needed. 
>
> If approved, we also request that the necessary allocation quota limits are increased so that 60 of these m3.large instances could be launched concurrently from my account. 
> 
> Thanks for your consideration and any help!


**Keywords:** microbial ecology, bioinformatics

**Opportunity questions:** checked box for “Classroom or training activities”

**Fields of Science:** “Other Biological Sciences”

**Documents and Publications:** Needed to attach my CV here.

---

## After submission

### Transfering credits from ACCESS to JetStream2
Once approved, and logged in, needed this page (https://allocations.access-ci.org/requests) in order to transfer ACCESS credits to specific resource as detailed on this page (https://allocations.access-ci.org/use-credits-overview). For the appropriate allocation request, selected "Choose New Action", then "Exchange". On next screen, chose Indiana Jetstream2 as Resource, clicked "Add Resource", entered all credits, needed to add a comment, and then submitted.

### Requesting increase in quotas
The starting quotas will not enable enough instances concurrently. Can build an email to submit a request when logged into jetstream2 here: https://jetstream2.exosphere.app/exosphere/getsupport

This is the text I submitted:

> Hi there :)
> 
> We plan to use this allocation (BIO230091) with 60 concurrent m3.large instances for a bioinformatics course we are running. The starting limit is set to 10. 
> 
> Could you please help with increasing the alloted quotas so that we will be able to run up to 60 m3.large instances concurrently on this allocation, including cores, ram, volume, ports, available IP addresses, and whatever other magic you folks take care of that i'm naive to?
> 
> Thank you for any help!
> -Mike
