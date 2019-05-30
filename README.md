# PASA Data

* Projected Assessment of System Adequacy
* ST PASA - Short  term PASA - 6 days
* MT PASA - Medium term PASA - 24 months
* USE - maximum expected unserved energy GWh
* POE - Probability of Exceedance
* UIGF - unconstrained intermittent generation forecast (wind/solar)
* DSP - Demand Side Participation
* LOLP - Loss of Load Probability

## Processing

In the ST PASA files there is a column called "Aggregate PASA availability" and then in the MT PASA files there is a column called "PASAAVAILABILITY_SCHEDULED".

I'm going to tentatively say that these two columns are equivalent -- but dealing with different time frames and granularity. As far as I understand they both exclude semi-scheduled or non-scheduled (semi-scheduled is generally larger utility wind or solar, non scheduled is small wind).


