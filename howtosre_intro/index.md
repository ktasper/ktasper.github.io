# Intro - How To SRE


## Intro
This is a series of posts I hope to keep updating as I progress through my own SRE journey. I am currently a lowly DevOps engineer by title but as we know DevOps is a methodology not really a title. I hope to show how I have implemented Site Reliability Engineering practices in my org and more importantly how I got people to care about it.

I have a good opportunity to show the benefits of SRE with a brand new SAAS project I was asked to been the "DevOps" for.

---
## Cover the basics
The new project is a new SAAS with lots of moving components. The very first thing I wanted to cover was the basic black box monitoring. I wanted to know if the databases were getting maxed out, if the lambda functions were taking 10+ seconds to execute. Etc.

### What to monitor

This project was on AWS. All I did to cover the basics was break down each component of the stack into each AWS service. For example:
- EC2
- Lambda
- API Gateway
- RDS
I then went into AWS metric explorer in CloudWatch and started to look at the built-in metrics AWS provides.
For example the following for RDS already exist:
- `ReadIOPS`
- `FreeStorageSpace`
- `WriteLatency`
- `CPUUtilization`
Take `CPUUtilization` for example. I looked at the `CPUUtilization` metrics over a 1 month period and saw that we were averaging about `7%` . Now this particular database is not used much, but you get the idea.

So I set an alarm `CPUUtilization >= 80 for 1 datapoints within 25 minutes` . 
- If the CPU Utilization is over 80% for 25 mins we will get an `SNS` email as something has or is going wrong.

Repeat x Times until you have covered all the basic monitoring for the stack.

If you are not sure what metrics you should be monitoring, just add the ones you think you need. If you need to add more in the future you can. But a good rule of thumb is to follow the [4 Golden Signals](https://sre.google/sre-book/monitoring-distributed-systems/)
- Latency
- Traffic
- Errors
- Saturation

But do not forget this rule: 
> As Simple as Possible, No Simpler

This is only the basic level monitoring, it should be just that, basic. If AWS are not giving it to you as a metric, its too complex for the moment. (Don't worry we wont neglect it)

### Why

Because doing SRE takes time, and unless you have no need for monitoring (so why are do you want to do SRE?) cover the basics first. You could even define your first SLO based on 1 or 2 pesky alerts you get sent 5 times each week. Remember Rome was not built in a day.

## TLDR
- Monitor the basics before you go fancy
- Get a good foundation to build upon.
